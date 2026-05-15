# Legal Documents (Bundled PDFs)

PDFs placed here are bundled into the app and displayed in-app via `PDFKit`.
Xcode synchronized folders pick them up automatically — no manual project edit needed.

## Required files

| Filename | Used by | Description |
| --- | --- | --- |
| `consumer_dispute_opinion.pdf` | `ConsumerDisputeOpinionSheet` | T.C. Adalet Bakanlığı Arabuluculuk Daire Başkanlığı görüş yazısı. Tüketici uyuşmazlığında, tüketicinin serbest iradesiyle arabuluculuk ücretini ödeyebileceği yönünde görüş bildiren resmi yazı. |

## Adding a new PDF

1. Drop the file into this folder (exact filename matters — referenced from code).
2. Build the app. If the PDF doesn't appear in the bundle, check Xcode's File Inspector → "Target Membership" and tick the Denklem target.
3. The viewer view loads it via `Bundle.main.url(forResource:withExtension:)`.

## Notes

- Keep filenames lowercase with underscores. They are matched case-sensitively at runtime on iOS.
- For very large PDFs (>5 MB), consider compressing — they ship in every app install.
