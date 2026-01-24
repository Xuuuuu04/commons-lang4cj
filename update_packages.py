import os
import re

# Use absolute path
base_dir = r"I:/commons-lang4cj/commons-lang4cj/src/test"
package_prefix = "commons_lang4cj.test"

print(f"Scanning {base_dir}...")

for root, dirs, files in os.walk(base_dir):
    for file in files:
        if file.endswith(".cj"):
            file_path = os.path.join(root, file)

            # Determine module name from directory structure
            rel_path = os.path.relpath(root, base_dir)
            # Normalize path separators
            module_name = rel_path.replace("\\", ".").replace("/", ".")

            new_package = f"{package_prefix}.{module_name}"

            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()

                # Replace package declaration
                # This regex looks for 'package' followed by whitespace and then the package name
                new_content = re.sub(r"^\s*package\s+[\w\.]+", f"package {new_package}", content, count=1, flags=re.MULTILINE)

                # Special handling for extension test
                if module_name == "extension":
                    if "import commons_lang4cj.extension" not in new_content:
                        # Add import after package declaration
                        new_content = new_content.replace(f"package {new_package}", f"package {new_package}\n\nimport commons_lang4cj.extension.*")

                if new_content != content:
                    print(f"Updating {file}: {new_package}")
                    with open(file_path, 'w', encoding='utf-8') as f:
                        f.write(new_content)
                else:
                    print(f"Skipping {file} (no change needed)")

            except Exception as e:
                print(f"Error processing {file}: {e}")
