#!/usr/bin/env python3
"""
create_topic.py

Create a template for topic to practice javascript.info section.

Usage:
    python create_topic.py <topic-name>

Example:
    python create_topic.py objects
    python create_topic.py arrays
    python create_topic.py closures

Creates:
    <topic>/
        index.html
        style.css
        <topic>.js
"""

import os
import sys


def slugify(name: str) -> str:
    """Lowercase and replace spaces/underscores with hyphens."""
    return name.strip().lower().replace(" ", "-").replace("_", "-")


def title_case(name: str) -> str:
    """Convert slug or raw name to a readable title."""
    return " ".join(word.capitalize() for word in name.replace("-", " ").replace("_", " ").split())


def create_css() -> str:
    return """*, *::before, *::after {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    font-family: "Segoe UI", system-ui, sans-serif;
    background: #0f0f23;
    color: #e8e8f0;
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 20px;
}

.badge {
    display: inline-block;
    font-size: 0.75rem;
    font-weight: 600;
    letter-spacing: 0.1em;
    text-transform: uppercase;
    color: #f7df1e;
    background: rgba(247, 223, 30, 0.1);
    border: 1px solid rgba(247, 223, 30, 0.3);
    border-radius: 999px;
    padding: 4px 14px;
    text-decoration: none;
    transition: background 0.2s, border-color 0.2s;
}

.badge:hover {
    background: rgba(247, 223, 30, 0.2);
    border-color: rgba(247, 223, 30, 0.6);
}

h1 {
    font-size: clamp(2rem, 5vw, 3.5rem);
    font-weight: 700;
    letter-spacing: -0.02em;
    color: #f7df1e;
    text-shadow: 0 0 40px rgba(247, 223, 30, 0.3);
}
"""


def create_html(topic_title: str, js_filename: str) -> str:
    return f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>{topic_title} - javascript.info</title>
    <link rel="stylesheet" href="style.css" />
</head>
<body>
    <a class="badge" href="https://javascript.info" target="_blank" rel="noopener">javascript.info</a>
    <h1>{topic_title}</h1>
    <script src="{js_filename}"></script>
</body>
</html>
"""


def create_js(topic_title: str) -> str:
    bar = "=" * (len(topic_title) + 4)
    return f"""/*
{bar}
  {topic_title}
{bar}
*/

"""


def main():
    if len(sys.argv) < 2:
        print("Usage: python create_topic.py <topic-name>")
        print("Example: python create_topic.py objects")
        sys.exit(1)

    slug = slugify(sys.argv[1])
    title = title_case(slug)
    js_filename = f"{slug}.js"

    # Create directory
    if os.path.exists(slug):
        print(f"Directory '{slug}' already exists. Aborting to avoid overwriting.")
        sys.exit(1)

    os.makedirs(slug)

    # Write style.css
    css_path = os.path.join(slug, "style.css")
    with open(css_path, "w", encoding="utf-8") as f:
        f.write(create_css())

    # Write index.html
    html_path = os.path.join(slug, "index.html")
    with open(html_path, "w", encoding="utf-8") as f:
        f.write(create_html(title, js_filename))

    # Write <topic>.js
    js_path = os.path.join(slug, js_filename)
    with open(js_path, "w", encoding="utf-8") as f:
        f.write(create_js(title))

    print(f"Created '{slug}/'")
    print(f"  {css_path}")
    print(f"  {html_path}")
    print(f"  {js_path}")


if __name__ == "__main__":
    main()
