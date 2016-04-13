# Edut - Social Learning Platform 

## Presentation of the project
[Dropbox PDF file](https://www.dropbox.com/s/m2ory2sly96vspw/Presentation-v.1.1.pdf?dl=0)

## Starting the application
Start the rails server.
```
rails s
```
Start Gulp
```
gulp
```
Start Sidekiq for Recommendable
```
bundle exec sidekiq -q recommendable
```
Start Redis
```
redis-server
```
Start Elasticsearch
```
sudo service elasticsearch start
```


*Comment lines in jquery.magnific-popup.js [node_modules] :*
```
 // This checks if we using node and want require jquery, but we already have it with asset pipeline
 // else if (typeof exports === 'object') {
 // Node/CommonJS
 // factory(require('jquery'));
 // }
 ```
