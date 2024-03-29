# itsankoff.github.io

Personal website 🦷

## Link
https://thetooth.io

## Local setup
* Run locally `make run`
* Build `make build` or `hugo build`
* Make a new blog post `make post POST=<<name>>`

## Deployment repo
https://github.com/itsankoff/itsankoff.github.io

## Resources
* Twitter card images:
    * The ideal image size for Twitter Cards is 800px by 418px, a 1.91:1 ratio.
    * For App Cards, you can go with 800px by 800px for a 1:1 ratio
    * Website Card videos is 1200px by 1200px, or 1:1 aspect ratio.
    * For App Card and Direct Message Card, the recommended size is 640px by 360px for a 16:9 ratio; 360px by 360px for a 1:1 ratio

## Troubleshooting
* If you receive errors during `make run` related to missing partial templates, make sure
    to update the latest version of the theme submodule dep. Go to themes/papermod and
    run `git pull origin master`
