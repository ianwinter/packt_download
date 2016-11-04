You can grab a book a day for free from Packt Pub, https://www.packtpub.com/packt/offers/free-learning.

This script allows you to download, not only those books, but all of the books listed in "My Books" within your account.

This was based on ruby 2.2.3 but you can change the `.ruby-version` file as there's nothing too exciting in here.

Once done install the required gems with bundler.

```
bundle install
rake bootstrap
```

You'll need to edit `config.yml` so that it has your email, password to login to packtpub.com and the path where you want the books to download, which, will need to exist already.

```
bundle exec ruby download-packt-books.rb
```

It's pretty basic so will output to screen. It won't download the book if the file already exists.

You'll end up with files like this:

```
Unity_Game_Development_Blueprints.epub
Unity_Game_Development_Blueprints.mobi
Unity_Game_Development_Blueprints.pdf
Unity_Game_Development_Blueprints_code.zip
```
