=begin
Template: Journey - Tailwind CSS
Author: Andy Leverenz, Pablo Blanco
Author URI: https://web-crunch.com, https://github.com/PabloB07 (pablobcl.dev)
Instructions: $ rails new myapp -d <postgresql, mysql, sqlite3> -m template.rb / URL
and finally: foreman start
=end
def add_template_repository
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("journey-"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      "--quiet",
      "https://github.com/PabloB07/Journey_Template",
      tempdir
    ].map(&:shellescape).join(" ")

    if (branch = __FILE__[%r{Journey_Template/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

def add_gems
  gem 'devise'
  gem 'friendly_id'
  gem 'sidekiq'
  gem 'name_of_person'
  gem 'omniauth'
  gem 'chilean-rutify'
  gem 'font-awesome-rails'
end

def add_users
  # Install Devise
  generate "devise:install"

  # Configure Devise
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }",
              env: 'development'
  route "root to: 'home#index'"

  # Create Devise User
  generate :devise, "User", "first_name", "last_name", "admin:boolean"

  insert_into_file "config/routes.rb",
    ", controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }\n\n",
    after: "devise_for :users"

  # Set admin boolean to false by default
  in_root do
    migration = Dir.glob("db/migrate/*").max_by{ |f| File.mtime(f) }
    gsub_file migration, /:admin/, ":admin, default: false"
  end
end

def copy_templates
  directory "app", force: true
end

def add_tailwind
  # Until PostCSS 8 ships with Webpacker/Rails we need to run this compatability version
  # See: https://tailwindcss.com/docs/installation#post-css-7-compatibility-build
  run "yarn add tailwindcss@npm:@tailwindcss/postcss7-compat postcss@^7 autoprefixer@^9"
  run "mkdir -p app/javascript/stylesheets"

  append_to_file("app/javascript/packs/application.js", 'import "stylesheets/application"')
  inject_into_file("./postcss.config.js", "\n    require('tailwindcss')('./app/javascript/stylesheets/tailwind.config.js'),", after: "plugins: [")

  run "mkdir -p app/javascript/stylesheets/components"
end

# Remove Application CSS
def remove_app_css
  remove_file "app/assets/stylesheets/application.css"
end

def add_sidekiq
  environment "config.active_job.queue_adapter = :sidekiq"

  insert_into_file "config/routes.rb",
    "require 'sidekiq/web'\n\n",
    before: "Rails.application.routes.draw do"

  sidekiq = <<-RUBY
    authenticate :user, lambda { |u| u.admin? } do
      mount Sidekiq::Web => '/sidekiq'
    end
  RUBY
  insert_into_file "config/routes.rb", "#{sidekiq}\n\n", after: "Rails.application.routes.draw do\n"
end

def add_foreman
  copy_file "Procfile"
end

def add_friendly_id
  generate "friendly_id"
end

# Main setup

add_template_repository
add_gems


after_bundle do
  add_users
  remove_app_css
  add_sidekiq
  add_foreman
  copy_templates
  add_tailwind
  add_friendly_id
  # Migrate & create a migration named add_omniauth_to_users
  rails_command "db:create"
  rails_command "db:migrate"
  rails_command "generate migration AddOmniauthToUsers provider:string uid:string"
  rails_command "db:migrate"

  git :init
  git add: "."
  git commit: %Q{ -m "Initial commit :fire: :package:" }

  say
  say "🥳 Project successfully created with this Template! 💎", :green
  say
  say "Switch to your app by running:"
  say "$ cd #{app_name}", :yellow
  say
  say "2 Ways to run:", :yellow
  say "$ rails server", :green
  say ""
  say "(foreman run web, sidekiq, Webpack & services)", :yellow
  say "$ foreman start", :green
  end
