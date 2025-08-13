# Makefile for working with quarto articles

help:    ## Show this help.
#	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e "s/\\$$//" | sed -e "s/##//"
	@grep -F -h "##" $(MAKEFILE_LIST) | grep -F -v grep | sed -e "s/\\$$//" | sed -e "s/##//"


docs:	## create the pdfs in docs from qmd files in pages
docs: $(patsubst pages/%.qmd, docs/%.pdf, $(wildcard pages/*.qmd))

docs/%.pdf: pages/%.qmd
	echo $< $@
	quarto render $< --to pdf

clean:   ## clean up
	rm -rf pages/tex2pdf.-*

branch:  ## Create a new branch (usage: make branch name=<name>).
	git checkout main && git pull origin main
	git checkout -b $(name)

commit:  ## Add and commit changes (usage: make commit msg="Commit message").
	git add .
	git commit -m "$(msg)"

push:    ## Push the current branch to GitHub.
	git push origin $(shell git branch --show-current)

show:    ## Show the branches.
	git branch --all

pull:    ## Pull the latest changes from the main branch.
	git checkout main
	git pull origin main
	git checkout -

make diff:  ## Show the git diff.
	git diff --word-diff

status:  ## Show the git status.
	git status

switch:  ## Switch to the main branch. (usage: make switch name=<name>)
	git switch $(name)

merge:   ## ADMIN: Merge the current branch into main
	@if [ "$$(git branch --show-current)" != "main" ]; then \
		git checkout main; \
		git pull origin main; \
		git merge $$(git branch --show-current); \
		git push origin main; \
	else \
		echo "This only works when you are in a branch."; \
	fi


delete-branch:   ## ADMIN: Delete the branch locally and remotely (usage: make delete-branch name=<name>).
	git branch -d $(name)
	git push origin --delete $(name)
