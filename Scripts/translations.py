#!/usr/bin/env python3
"""
Export and import the Younique string catalog as CSV for offline review.

Usage:
  python3 Scripts/translations.py export [path/to/translations.csv]
  python3 Scripts/translations.py import [path/to/translations.csv]

Defaults to ./translations.csv. Edit the CSV in Numbers/Excel; running import
writes changes back to Younique/Younique/Localizable.xcstrings while keeping
the rest of the file intact.

Columns:
  key       - identifier in the catalog (read-only, do not change)
  nl        - Dutch text. If you edit this, the script adds an explicit "nl"
              localization to the catalog so the new text shows up at runtime.
  en        - English text. Edits update the value and mark state=translated.
  en_state  - reported only; updated automatically on import.
"""
import csv
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CATALOG = ROOT / "Younique" / "Localizable.xcstrings"
DEFAULT_CSV = ROOT / "translations.csv"


def load_catalog():
    with CATALOG.open("r", encoding="utf-8") as f:
        return json.load(f)


def save_catalog(data):
    text = json.dumps(data, indent=2, ensure_ascii=False, separators=(",", " : "))
    CATALOG.write_text(text + "\n", encoding="utf-8")


def get_value(entry, locale):
    stringUnit = (
        entry.get("localizations", {})
        .get(locale, {})
        .get("stringUnit", {})
    )
    return stringUnit.get("value", ""), stringUnit.get("state", "")


def set_value(entry, locale, value, state="translated"):
    localizations = entry.setdefault("localizations", {})
    locale_entry = localizations.setdefault(locale, {})
    locale_entry["stringUnit"] = {"state": state, "value": value}


def export(csv_path: Path):
    data = load_catalog()
    strings = data.get("strings", {})
    rows = []
    for key in sorted(strings.keys()):
        entry = strings[key]
        nl_value, _ = get_value(entry, "nl")
        # Source language defaults to the key itself when no explicit nl localization.
        nl_text = nl_value if nl_value else key
        en_value, en_state = get_value(entry, "en")
        rows.append({
            "key": key,
            "nl": nl_text,
            "en": en_value,
            "en_state": en_state,
        })
    with csv_path.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=["key", "nl", "en", "en_state"])
        writer.writeheader()
        writer.writerows(rows)
    print(f"Exported {len(rows)} strings → {csv_path}")


def import_csv(csv_path: Path):
    original_text = CATALOG.read_text(encoding="utf-8")
    data = json.loads(original_text)
    strings = data.get("strings", {})
    changed_nl = 0
    changed_en = 0
    skipped_unknown = 0

    with csv_path.open("r", encoding="utf-8", newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            key = row.get("key", "")
            if not key or key not in strings:
                skipped_unknown += 1
                continue

            entry = strings[key]

            nl_new = row.get("nl", "")
            current_nl, _ = get_value(entry, "nl")
            current_nl_effective = current_nl if current_nl else key
            if nl_new and nl_new != current_nl_effective:
                set_value(entry, "nl", nl_new, state="translated")
                changed_nl += 1
            elif nl_new == key and current_nl:
                # User reset nl back to key — drop explicit nl localization.
                entry.get("localizations", {}).pop("nl", None)
                changed_nl += 1

            en_new = row.get("en", "")
            current_en, _ = get_value(entry, "en")
            if en_new != current_en:
                set_value(entry, "en", en_new, state="translated")
                changed_en += 1

    if changed_en or changed_nl:
        save_catalog(data)
        print(f"Updated {changed_en} EN values, {changed_nl} NL values.")
    else:
        print("No changes detected — catalog left untouched.")
    if skipped_unknown:
        print(f"Skipped {skipped_unknown} unknown keys (not in catalog).")


def main():
    if len(sys.argv) < 2 or sys.argv[1] not in {"export", "import"}:
        print(__doc__)
        sys.exit(1)

    cmd = sys.argv[1]
    csv_path = Path(sys.argv[2]) if len(sys.argv) > 2 else DEFAULT_CSV

    if cmd == "export":
        export(csv_path)
    else:
        if not csv_path.exists():
            print(f"CSV not found: {csv_path}")
            sys.exit(1)
        import_csv(csv_path)


if __name__ == "__main__":
    main()
