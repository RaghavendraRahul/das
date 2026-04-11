import os

file_path = r'c:\Users\PRAVE\Downloads\pm_frontend_flutter\pm_frontend_flutter\lib\src\features\today\widgets\activity_catalog.dart'

try:
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    new_content = content.replace('LongPressDraggable', 'Draggable')

    if content == new_content:
        print("No changes needed.")
    else:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print("Successfully replaced LongPressDraggable with Draggable.")

except Exception as e:
    print(f"Error: {e}")
