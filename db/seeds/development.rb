# This will be run during `rake db:seed` in the :development environment.

include Sprig::Helpers

sprig [User, Category, Course, Section, Article, Comment, Activity]
