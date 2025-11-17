#!/usr/bin/env bash
set -euo pipefail

echo "This helper prints GH API commands to fetch your user project and column IDs. Run these locally where gh is authenticated."

echo
echo "1) List user projects (may require preview header):"
echo "gh api users/SiderealMollusk/projects -H \"Accept: application/vnd.github.inertia-preview+json\" -q '.[] | \"ID:\t\(.id)\tName:\t\(.name)\tURL:\t\(.html_url)\"'"

echo
echo "2) Once you have a project ID, list its columns (replace PROJECT_ID):"
echo "gh api projects/PROJECT_ID/columns -H \"Accept: application/vnd.github.inertia-preview+json\" -q '.[] | \"ID:\t\(.id)\tName:\t\(.name)\"'"

echo
echo "3) To get an issue numeric DB id (needed for creating a linked card):"
echo "gh api repos/SiderealMollusk/Sidereal-infrastructure/issues/1 -q '.id'"

echo
echo "If the 'users' projects API returns 404, try opening your project page in a browser and copy the numeric column ID from the UI (or create a repo-level project instead)."
