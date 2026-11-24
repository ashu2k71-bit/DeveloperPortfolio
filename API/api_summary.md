# REST API Interaction

## What is a REST API?

A REST API lets applications interact with resources through URLs and standard HTTP methods. In this exercise, GET requests retrieve my GitHub profile and sample posts. The servers return JSON that I can process with jq and Python.

## Observed HTTP status codes

| Request | Observed status |
| --- | --- |
| GitHub profile | 200 |
| JSONPlaceholder posts | 200 |
| Unknown GitHub API route | 404 |

HTTP 200 means that the request succeeded.
HTTP 404 means that the requested resource could not be found.

## Post count

The command jq length API/sample_posts.json returned **100**.
It counts the objects in the top-level JSON array.

## Extracting fields with jq

```bash
jq '{name:.name, repos:.public_repos, followers:.followers, joined:.created_at}' API/github_profile.json
```

The braces create a new JSON object. Labels before colons are output keys, and dot-prefixed names read fields from the original response.

| Mapping | Meaning |
| --- | --- |
| name:.name | Profile display name |
| repos:.public_repos | Number of public repositories |
| followers:.followers | Number of followers |
| joined:.created_at | Account creation timestamp |
