# Documentation for Val's Wiki

_For such a simple concept, there's a fair amount of activity going on under the hood of my wiki/digital garden. This documentation should help readers understand how I built this site. I focused on simplicity so that people without lots of coding experience can replicate my setup for their own digital gardens._  

# GitHub Workflows

## GitHub Pages Deployment 
- Filepath: .github/workflows/ci.yaml  

This file is a GitHub Actions workflow configuration for deploying a Jekyll site to GitHub Pages. This workflow automates the process of building and deploying a Jekyll site to GitHub Pages whenever changes are pushed to the main branch.  

1. **Trigger**: The workflow is triggered by a push to the `main` branch.

2. **Job Definition**:  
    Job Name: build  
    Runner: ubuntu-latest

3. **Job Steps**:  
    A. Check Out Code: Uses the `actions/checkout@v2` action to check out the repository code.

    B. Set up Ruby: Uses the `ruby/setup-ruby@v1` action to set up Ruby version x.y.z. Caches the Bundler dependencies and specifies Bundler version a.b.c.

    C. Install Dependencies: Runs `bundle install` to install the required Ruby gems.

    D. Build Site: Runs `bundle exec jekyll build` to build the Jekyll site.

    E. Deploy to GitHub Pages: Uses the `peaceiris/actions-gh-pages@v3` action to deploy the built site to the `gh-pages` branch. Uses the `GITHUB_TOKEN` secret for authentication and specifies the directory containing the built site (./_site).  

## Update Listings
- Filepath: .github/workflows/update_listings.yml  

This file is a GitHub Actions workflow configuration for updating listings in a repository. This workflow automates the process of generating and committing updates to `_data/listings.json` in the repository whenever changes are pushed to the `main` branch. With this workflow, I do not have to manually add wiki folders and files to `_data/listings.json` whenever I create wiki entries.  

1. **Trigger**: The workflow is triggered by a push to the `main` branch.  

2. **Job Definition**:  
    Job Name: update-listings  
    Runner: ubuntu-latest  

3. **Job Steps**:  
    A. Check Out Code: Uses the `actions/checkout@v2` action to check out the repository code.

    B. Set up Ruby: Uses the `ruby/setup-ruby@v1` action to set up Ruby version x.y.z.

    C. Install Dependencies: Runs `bundle install` to install the required Ruby gems.

    D. Generate Listings:  
        - Runs `ruby generate_listings.rb` to generate the listings.  
        - Sets an environment variable `WIKI_DIR` to the correct path (./wiki).  

    E. Commit and Push Changes:  
        - Configures the GitHub Actions bot with a global Git username and email.  
        - Checks if there are any changes in the repository.  
        - If changes are present:  
                - Adds `_data/listings.json` and `Gemfile.lock` to the Git index.  
                - Commits the changes with a message 'Update listings.json and Gemfile.lock'.  
                - Pushes the changes to the repository.  
        - If no changes are present, outputs a message "No changes to commit".  
        - Uses the `GITHUB_TOKEN` secret for authentication.  

# Automation: Updating Folders & Files 

## Generate Listings
- File: generate_listings.rb

This Ruby script generates a JSON listing of files and directories within a specified directory (the `wiki` directory). This helps create navigational elements for the wiki. 

1. **Imports Required Libraries**:
    - `json` for JSON manipulation.
    - `fileutils` for file and directory operations.
    - `yaml` for reading YAML configuration files.

2. **Load Configuration**:
    - Reads the `_config.yml` file to get the directory to list.
    - Retrieves the directory from the `directory_to_list` key in the configuration file.

3. **Set Directory to List**: Uses an environment variable `WIKI_DIR` if it is set; otherwise, defaults to the directory specified in the configuration file.  

4. **Check Directory Existence**: Verifies that the specified directory exists. If not, it prints an error message and exits.

5. **Generate Listings Function**: Defines a recursive function `generate_listings` that creates a nested structure of folders and files:
    - Folders: Contains subfolders and their respective listings.
    - Files: Contains file names and paths within the directory.

6. **Ensure Data Directory Exists**: Ensures that the `_data` directory exists and creates it if necessary.

7. **Generate Listings**: Calls the `generate_listings` function on the specified directory to create a nested listing.

8. **Write Listings to JSON**: Writes the generated listings to the `listings.json` file in the `_data` directory using pretty-printed JSON format.

## Wiki Home Page
- Filepath: wiki/index.html

The automation within this file creates a section of the home page for displaying wiki topics (folders) dynamically. I do not have to manually update this file each time I add or remove a wiki folder. This automation includes the following elements:
- **JavaScript**: A script to fetch and display listings from `listings.json` within the `#wiki-topics` section.
- **Liquid**: Template code that involves four main tasks. 
    - Assigns all pages containing "wiki" in their path to a `folders` variable.  
    - Processes the folder paths to create a unique, sorted list of wiki folders (`wikifolders`).  
    - Dynamically generates links to each wiki folder, excluding markdown and HTML files.  
    - Lists all notes in the wiki at the end of the home page.
- **CSS**: Styles for the `wiki topics` container, making it a three-column grid with borders and padding.

# Includes

The `_includes` directory contains small HTML files that can be inserted into layouts. Most of the include files for my wiki are based on the _Minima_ theme. [You can read about them here](https://github.com/jekyll/minima/blob/master/README.md#includes).  

# Layouts

The `_layouts` directory contains HTML files that dictate the organization of information and appearance of various wiki pages. Some layout files include CSS styling. A few layout files are standards for the _Minima_ theme, and others are drafts for future wiki ideas. The primary layout files for my wiki are provided below:  

- `default.html`: Defines the layout for wiki entries and links pages within specific wiki folders. 
- `folder.html`: Defines the layout for the index pages for specific wiki folders.
- `wiki.html`: Defines the layout for the main wiki page (wiki/index.html).


# Wiki Structure 

Wiki  
|-- Wiki Index  
|  
|-- Wiki Folders (Topics)  
|    |  
|    |-- Folder 1  
|    |    |-- Wiki Folder Index  
|    |    |-- Note 1.1  
|    |    |-- Note 1.2  
|    |    |-- Links  
|    |  
|    |-- Folder 2  
|    |    |-- Wiki Folder Index  
|    |    |-- Note 2.1  
|    |    |-- Note 2.2  
|    |    |-- Links  

### Wiki Folder Contents

- **Index**: Functions as the home page for each folder. It contains a summary of the folder contents and a list of that folder's files.
- **Notes**: Markdown files that serve as wiki entries. 
- **Links**: A list of websites related to that folder's topic.
- **Snippets**: Images and other media related to that folder's topic.

# Static Site
When I am tinkering with my GitHub site locally, I use [Jekyll](https://jekyllrb.com/docs/) to preview my work. Here are the commands I use to update my `listings.json` file and to build my static site:  

```
ruby generate_listings.rb
bundle exec jekyll build
bundle exec jekyll serve
```
Once the site is built and available on my local server, I navigate to http://localhost:4000/ to view it. 

# Git Commands 
The standard commands for updating my GitHub site are second-nature by now. But in case a refresher is needed, here are the commands I typically use:  

```
cd valwade275.github.io
git status (check on changes)
git pull (update local repo)
git add . (add changes)
git commit -m "message"
git push
```

If something goes wrong, refer to the appropriate [Git Guides](https://github.com/git-guides) for assistance. 
- [status](https://github.com/git-guides/git-status)
- [pull](https://github.com/git-guides/git-pull)
- [add](https://github.com/git-guides/git-add)
- [commit](https://github.com/git-guides/git-commit)
- [push](https://github.com/git-guides/git-push) 

If you get tangled up in the terminal, [here's a quick reference for the most common commands](https://gist.github.com/bradtraversy/cc180de0edee05075a6139e42d5f28ce). 