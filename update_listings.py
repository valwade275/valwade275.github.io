import os
import yaml

def get_folders_files(root_dir):
    folders = []
    files = []

    for dirpath, dirnames, filenames in os.walk(root_dir):
        for dirname in dirnames:
            folders.append({
                'name': dirname,
                'path': os.path.join(dirpath, dirname).replace(root_dir, '')
            })
        for filename in filenames:
            files.append({
                'name': filename,
                'path': os.path.join(dirpath, filename).replace(root_dir, '')
            })

    return folders, files

def update_listings_yml(folders, files, output_file):
    data = {
        'folders': folders,
        'files': files
    }

    with open(output_file, 'w') as f:
        yaml.dump(data, f, default_flow_style=False)

if __name__ == '__main__':
    root_dir = 'wiki'  # Change this to your wiki directory
    output_file = '_data/listings.yml'

    folders, files = get_folders_files(root_dir)
    update_listings_yml(folders, files, output_file)

    print(f'Updated {output_file} with {len(folders)} folders and {len(files)} files.')
