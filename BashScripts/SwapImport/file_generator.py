
# Create sample files for practicing Exercise #1

# Create .swap23 files with numbered lines
sample_swap23_files = {
    "data1.swap23": "line 1: First line of data\nline 2: Second line of data\nline 3: Third line of data\nline 4: Fourth line of data\nline 5: Fifth line of data",
    "data2.swap23": "1: One\n2: Two\n3: Three",
    "records.swap23": "Header information here\nData point A\nData point B\nData point C\nData point D\nData point E\nData point F"
}

# Create .py files with "import" statements
py_with_import = {
    "module1.py": "import os\nimport sys\nimport json\n\ndef hello():\n    print('Hello World')\n\nif __name__ == '__main__':\n    hello()",
    "module2.py": "from pathlib import Path\nimport pandas as pd\nimport numpy as np\n\ndef process_data():\n    pass",
    "utilities.py": "import argparse\nimport re\nimport urllib.request\n\nclass Processor:\n    def run(self):\n        pass"
}

# Create .py files without "import" statements
py_without_import = {
    "simple.py": "def add(a, b):\n    return a + b\n\ndef subtract(a, b):\n    return a - b",
    "config.py": "# Configuration file\nDATABASE_URL = 'localhost:5432'\nDEBUG_MODE = True\nTIMEOUT = 30"
}

# Create files with other extensions
other_files = {
    "readme.txt": "This is a readme file\nIt contains information\nNo swap or import needed",
    "config.ini": "[settings]\ndebug = true\nport = 8080",
    "data.csv": "name,age,city\nJohn,30,NYC\nJane,25,LA"
}

# Write all files
all_files = {**sample_swap23_files, **py_with_import, **py_without_import, **other_files}

for filename, content in all_files.items():
    with open(filename, 'w') as f:
        f.write(content)

print("Sample files created successfully!")
print("\nFiles created:")
for filename in all_files.keys():
    print(f"  - {filename}")
