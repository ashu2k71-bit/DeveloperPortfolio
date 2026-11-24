"""Author: Ashwani Singh. Summarise saved REST API responses."""

import json
from pathlib import Path

api_folder = Path(__file__).resolve().parent

with (api_folder / "github_profile.json").open(encoding="utf-8") as file:
    profile = json.load(file)

with (api_folder / "sample_posts.json").open(encoding="utf-8") as file:
    posts = json.load(file)

print("GitHub username:", profile["login"])
print("Name:", profile.get("name"))
print("Public repositories:", profile["public_repos"])
print("Followers:", profile["followers"])
print("Joined:", profile["created_at"])
print("Number of sample posts:", len(posts))
