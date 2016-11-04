You can grab a book a day for free from Packt Pub, https://www.packtpub.com/packt/offers/free-learning.

This script allows you to download, not only those books, but all of the books listed in "My Books" within your account.

This was based on ruby 2.2.3 but you can change the `.ruby-version` file as there's nothing too exciting in here.

## Installation

Once done install the required gems with bundler.

```
bundle install
rake bootstrap
```

## Running

You'll need to edit `config.yml` so that it has your email, password to login to packtpub.com and the path where you want the books to download, which, will need to exist already.

```
bundle exec ruby download-packt-books.rb
```

It won't download the book if the file already exists in the `config/books.yml` list. Otherwise right now it won't output anything.

You'll end up with files like this:

```
Unity_Game_Development_Blueprints.epub
Unity_Game_Development_Blueprints.mobi
Unity_Game_Development_Blueprints.pdf
Unity_Game_Development_Blueprints_code.zip
```

## Credits / References

I currenly use an older version of https://github.com/draconar/grab_packt to actually do the fetching of the books.
