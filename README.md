# 🧗🏻‍♂️ Journey - Template
A rapid Rails 6 application template for personal use. This particular template utilizes [Tailwind CSS](https://tailwindcss.com/), a utility-first CSS framework for rapid UI development.

Tailwind depends on Webpack so this also comes bundled with [webpacker](https://github.com/rails/webpacker) support.

### 💎 Included gems

- [devise](https://github.com/plataformatec/devise)
- [friendly_id](https://github.com/norman/friendly_id)
- [sidekiq](https://github.com/mperham/sidekiq)
- [name_of_person](https://github.com/basecamp/name_of_person)
- [omniauth-twitter](https://github.com/arunagw/omniauth-twitter)
- [font-awesome](https://github.com/font-awesome-rails)
- [RUTify](https://github.com/mihailpozarski/chilean-rutify) <-- ⚠️ Rutify works only in projects which accepts Chilean 🇨🇱 national data. plus, if you want to remove the rutify method and validation go to `Journey_Template/app/models/user.rb` open that model file and remove them. ⚠️

### 🍀 Tailwind CSS by default
With Rails 6 we have webpacker by default now. Using PostCSS we can install Tailwind as a base CSS framework to harness. I prefer Tailwind due to it's un-opinionated approach.

## 🔨 How it works

When creating a new rails app simply pass the template file through.

### 👨🏻‍🎨 Creating a new app

```ruby
rails new example_app -d <postgresql, mysql, sqlite3> -m template.rb

```
Or
```ruby
rails new example_app -d <postgresql, mysql, sqlite3> -m "Raw URL"
```
### 🤔 Remember to add Twitter secret & api Key
```ruby
EDITOR=nano rails credentials:edit
```
### Finally
```ruby
foreman start
```
### ✅ Once installed what do I get?
- Webpack support + Tailwind CSS configured in the `app/javascript` directory.
- Devise with a new `name` field already migrated in. The name field maps to the `first_name` and `last_name` fields in the database thanks to the `name_of_person` gem.
- Enhanced views using Tailwind CSS.
- Support for Friendly IDs thanks to the handy [friendly_id](https://github.com/norman/friendly_id) gem. Note that you'll still need to do some work inside your models for this to work. This template installs the gem and runs the associated generator.
- Optional Foreman support thanks to a `Procfile`. Once you scaffold the template, run `foreman start` to initalize and head to `locahost:5000` to get `rails server`, `sidekiq` and `bin/webpack-dev-server` running all in one terminal instance. Note: Webpack will still compile down with just `rails server` if you don't want to use Foreman. Foreman needs to be installed as a global gem on your system for this to work. i.e. `gem install foreman`
- A custom scaffold view template when generating theme resources (Work in progress).
- Git initialization out of the box
- PurgeCSS configuration to help with CSS file sizes
- Custom defaults for button and form elements
- Omniauth with Twitter all views, model, controllers and shared are improved
- RUTify integration, method and validated are in User model

### 🔜 Things to come on this template
- ~~RUTify integration~~
- MAdmin integration
- Noticed integration
- Kaminari
- Simple_form

Thanks 🤟🏻.
