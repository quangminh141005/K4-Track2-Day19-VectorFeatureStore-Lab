"""Execute only the four required notebooks, preserving outputs for submission."""
from pathlib import Path
import jupytext
from nbclient import NotebookClient

ROOT = Path(__file__).resolve().parent.parent


def main():
    for source in sorted((ROOT / "notebooks").glob("0[1-4]*.py")):
        print(f"Executing {source.name}", flush=True)
        notebook = jupytext.read(source)
        notebook.metadata["kernelspec"] = {
            "display_name": "Python 3", "language": "python", "name": "python3"
        }
        try:
            NotebookClient(
                notebook, timeout=900,
                resources={"metadata": {"path": str(ROOT / "notebooks")}},
            ).execute()
        finally:
            jupytext.write(notebook, source.with_suffix(".ipynb"))
        print(f"PASS {source.name}", flush=True)


if __name__ == "__main__":
    main()
