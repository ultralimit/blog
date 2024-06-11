cd /d E:\MkDocs\blog
call venv/Scripts/activate
git config user.name ultralimit
git config user.email 113653774+ultralimit@users.noreply.github.com
git add *
git commit -m "commit"
git remote add origin git@github-ultralimit:ultralimit/blog.git
git remote set-url origin git@github-ultralimit:ultralimit/blog.git
git push -u origin main
mkdocs gh-deploy
exit
