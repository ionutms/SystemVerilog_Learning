"""
Read SystemVerilog files and display their content in Jupyter Notebook.
This utility function reads all SystemVerilog files from a specified path
and displays their content in a formatted manner using Markdown.
"""

import glob

from IPython.display import Markdown, display


def read_sv_files(files_path: str) -> None:
    for file in sorted(glob.glob(f"{files_path}*.sv")):
        with open(file, "r") as source_file:
            display(Markdown(f"```systemverilog\n{source_file.read()}\n```"))
