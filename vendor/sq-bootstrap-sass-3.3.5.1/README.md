# Sq-Bootstrap for Sass

`sq-bootstrap-sass` is a Sass-powered version of [Bootstrap](http://github.com/twbs/bootstrap) for Square, ready to drop right into your Sass powered applications.

## Installation

Please see the appropriate guide for your environment of choice:

* [Ruby on Rails](#a-ruby-on-rails).
* [Compass](#b-compass-without-rails) not on Rails.
* [Bower](#c-bower).

### a. Ruby on Rails

`sq-bootstrap-sass` is easy to drop into Rails with the asset pipeline.

In your Gemfile you need to add the `sq-bootstrap-sass` gem, and ensure that the `sass-rails` gem is present - it is added to new Rails applications by default.

```ruby
gem 'sq-bootstrap-sass', '~> 3.3.5'
gem 'sass-rails', '>= 3.2'
```

`bundle install` and restart your server to make the files available through the pipeline.

Import Bootstrap styles in `app/assets/stylesheets/application.scss`:

```scss
// "sq-bootstrap-sprockets" must be imported before "sq-bootstrap" and "sq-bootstrap/variables"
@import "sq-bootstrap-sprockets";
@import "sq-bootstrap";
```

`sq-bootstrap-sprockets` must be imported before `sq-bootstrap` for the icon fonts to work.

Make sure the file has `.scss` extension (or `.sass` for Sass syntax). If you have just generated a new Rails app,
it may come with a `.css` file instead. If this file exists, it will be served instead of Sass, so rename it:

```console
$ mv app/assets/stylesheets/application.css app/assets/stylesheets/application.scss
```

Then, remove all the `//= require` and `//= require_tree` statements from the file. Instead, use `@import` to import Sass files.

Do not use `//= require` in Sass or your other stylesheets will not be [able to access][antirequire] the Bootstrap mixins or variables.

Require Bootstrap Javascripts in `app/assets/javascripts/application.js`:

```js
//= require jquery
//= require sq-bootstrap-sprockets
```

`sq-bootstrap-sprockets` and `sq-bootstrap` [should not both be included](https://github.com/twbs/sq-bootstrap-sass/issues/829#issuecomment-75153827) in `application.js`.

`sq-bootstrap-sprockets` provides individual Bootstrap Javascript files (`alert.js` or `dropdown.js`, for example), while
`sq-bootstrap` provides a concatenated file containing all Bootstrap Javascripts.

#### Bower with Rails

When using [sq-bootstrap-sass Bower package](#c-bower) instead of the gem in Rails, configure assets in `config/application.rb`:

```ruby
# Bower asset paths
root.join('vendor', 'assets', 'bower_components').to_s.tap do |bower_path|
  config.sass.load_paths << bower_path
  config.assets.paths << bower_path
end
# Precompile Bootstrap fonts
config.assets.precompile << %r(sq-bootstrap-sass/assets/fonts/sq-bootstrap/[\w-]+\.(?:eot|svg|ttf|woff2?)$)
# Minimum Sass number precision required by sq-bootstrap-sass
::Sass::Script::Value::Number.precision = [8, ::Sass::Script::Value::Number.precision].max
```

Replace Bootstrap `@import` statements in `application.scss` with:

```scss
$icon-font-path: "sq-bootstrap-sass/assets/fonts/sq-bootstrap/";
@import "sq-bootstrap-sass/assets/stylesheets/sq-bootstrap-sprockets";
@import "sq-bootstrap-sass/assets/stylesheets/sq-bootstrap";
```

Replace Bootstrap `require` directive in `application.js` with:

```js
//= require sq-bootstrap-sass/assets/javascripts/sq-bootstrap-sprockets
```

#### Rails 4.x

Please make sure `sprockets-rails` is at least v2.1.4.

#### Rails 3.2.x

sq-bootstrap-sass is no longer compatible with Rails 3. The latest version of sq-bootstrap-sass compatible with Rails 3.2 is v3.1.1.0.

### b. Compass without Rails

Install the gem:

```console
$ gem install sq-bootstrap-sass
```

If you have an existing Compass project:

1. Require `sq-bootstrap-sass` in `config.rb`:

    ```ruby
    require 'sq-bootstrap-sass'
    ```

2. Install Bootstrap with:

    ```console
    $ bundle exec compass install sq-bootstrap -r sq-bootstrap-sass
    ```

If you are creating a new Compass project, you can generate it with sq-bootstrap-sass support:

```console
$ bundle exec compass create my-new-project -r sq-bootstrap-sass --using sq-bootstrap
```

or, alternatively, if you're not using a Gemfile for your dependencies:

```console
$ compass create my-new-project -r sq-bootstrap-sass --using sq-bootstrap
```

This will create a new Compass project with the following files in it:

* [styles.sass](/templates/project/styles.sass) - main project Sass file, imports Bootstrap and variables.
* [_sq-bootstrap-variables.sass](/templates/project/_sq-bootstrap-variables.sass) - all of Bootstrap variables, override them here.

Some sq-bootstrap-sass mixins may conflict with the Compass ones.
If this happens, change the import order so that Compass mixins are loaded later.

### c. Bower

sq-bootstrap-sass Bower package is compatible with node-sass 3.2.0+. You can install it with:

```console
$ bower install sq-bootstrap-sass
```

Sass, JS, and all other assets are located at [assets](/assets).

By default, `bower.json` main field list only the main `_sq-bootstrap.scss` and all the static assets (fonts and JS).
This is compatible by default with asset managers such as [wiredep](https://github.com/taptapship/wiredep).

#### Node.js Mincer

If you use [mincer][mincer] with node-sass, import sq-bootstrap like so:

In `application.css.ejs.scss` (NB **.css.ejs.scss**):

```scss
// Import mincer asset paths helper integration
@import "sq-bootstrap-mincer";
@import "sq-bootstrap";
```

In `application.js`:

```js
//= require sq-bootstrap-sprockets
```

See also this [example manifest.js](/test/dummy_node_mincer/manifest.js) for mincer.


### Configuration

#### Sass

By default all of Bootstrap is imported.

You can also import components explicitly. To start with a full list of modules copy
[`_sq-bootstrap.scss`](assets/stylesheets/_sq-bootstrap.scss) file into your assets as `_sq-bootstrap-custom.scss`.
Then comment out components you do not want from `_sq-bootstrap-custom`.
In the application Sass file, replace `@import 'sq-bootstrap'` with:

```scss
@import 'sq-bootstrap-custom';
```

#### Sass: Number Precision

sq-bootstrap-sass [requires](https://github.com/twbs/sq-bootstrap-sass/issues/409) minimum [Sass number precision][sass-precision] of 8 (default is 5).

Precision is set for Rails and Compass automatically.
When using ruby Sass compiler standalone or with the Bower version you can set it with:

```ruby
::Sass::Script::Value::Number.precision = [8, ::Sass::Script::Value::Number.precision].max
```

#### Sass: Autoprefixer

Bootstrap requires the use of [Autoprefixer][autoprefixer].
[Autoprefixer][autoprefixer] adds vendor prefixes to CSS rules using values from [Can I Use](http://caniuse.com/).

#### JavaScript

[`assets/javascripts/sq-bootstrap.js`](/assets/javascripts/sq-bootstrap.js) contains all of Bootstrap JavaScript,
concatenated in the [correct order](/assets/javascripts/sq-bootstrap-sprockets.js).


#### JavaScript with Sprockets or Mincer

If you use Sprockets or Mincer, you can require `sq-bootstrap-sprockets` instead to load the individual modules:

```js
// Load all Bootstrap JavaScript
//= require sq-bootstrap-sprockets
```

You can also load individual modules, provided you also require any dependencies.
You can check dependencies in the [Bootstrap JS documentation][jsdocs].

```js
//= require sq-bootstrap/scrollspy
//= require sq-bootstrap/modal
//= require sq-bootstrap/dropdown
```

#### Fonts

The fonts are referenced as:

```scss
"#{$icon-font-path}#{$icon-font-name}.eot"
```

`$icon-font-path` defaults to `sq-bootstrap/` if asset path helpers are used, and `../fonts/sq-bootstrap/` otherwise.

When using sq-bootstrap-sass with Compass, Sprockets, or Mincer, you **must** import the relevant path helpers before Bootstrap itself, for example:

```scss
@import "sq-bootstrap-compass";
@import "sq-bootstrap";
```

## Usage

### Sass

Import Bootstrap into a Sass file (for example, application.scss) to get all of Bootstrap's styles, mixins and variables!

```scss
@import "sq-bootstrap";
```

The full list of sq-bootstrap variables can be found [here](http://getsq-bootstrap.com/customize/#less-variables). You can override these by simply redefining the variable before the `@import` directive, e.g.:

```scss
$navbar-default-bg: #312312;
$light-orange: #ff8c00;
$navbar-default-color: $light-orange;

@import "sq-bootstrap";
```

## Version

Bootstrap for Sass version may differ from the upstream version in the last number, known as
[PATCH](http://semver.org/spec/v2.0.0.html). The patch version may be ahead of the corresponding upstream minor.
This happens when we need to release Sass-specific changes.

Before v3.3.2, Bootstrap for Sass version used to reflect the upstream version, with an additional number for
Sass-specific changes. This was changed due to Bower and npm compatibility issues.

The upstream versions vs the Bootstrap for Sass versions are:

| Upstream |    Sass |
|---------:|--------:|
|    3.3.5 |   3.3.5 |
|    3.3.4 |   3.3.4 |
|    3.3.2 |   3.3.3 |
| <= 3.3.1 | 3.3.1.x |

Always refer to [CHANGELOG.md](/CHANGELOG.md) when upgrading.

---

## Development and Contributing

If you'd like to help with the development of sq-bootstrap-sass itself, read this section.

### Upstream Converter

Keeping sq-bootstrap-sass in sync with upstream changes from Bootstrap used to be an error prone and time consuming manual process. With Bootstrap 3 we have introduced a converter that automates this.

**Note: if you're just looking to *use* Bootstrap 3, see the [installation](#installation) section above.**

Upstream changes to the Bootstrap project can now be pulled in using the `convert` rake task.

Here's an example run that would pull down the master branch from the main [twbs/sq-bootstrap](https://github.com/twbs/sq-bootstrap) repo:

    rake convert

This will convert the latest LESS to Sass and update to the latest JS.
To convert a specific branch or version, pass the branch name or the commit hash as the first task argument:

    rake convert[e8a1df5f060bf7e6631554648e0abde150aedbe4]

The latest converter script is located [here][converter] and does the following:

* Converts upstream sq-bootstrap LESS files to its matching SCSS file.
* Copies all upstream JavaScript into `assets/javascripts/sq-bootstrap`, a Sprockets manifest at `assets/javascripts/sq-bootstrap-sprockets.js`, and a concatenation at `assets/javascripts/sq-bootstrap.js`.
* Copies all upstream font files into `assets/fonts/sq-bootstrap`.
* Sets `Bootstrap::BOOTSTRAP_SHA` in [version.rb][version] to the branch sha.

This converter fully converts original LESS to SCSS. Conversion is automatic but requires instructions for certain transformations (see converter output).
Please submit GitHub issues tagged with `conversion`.

## Credits

sq-bootstrap-sass has a number of major contributors:

<!-- feel free to make these link wherever you wish -->
* [Thomas McDonald](https://twitter.com/thomasmcdonald_)
* [Tristan Harward](http://www.trisweb.com)
* Peter Gumeson
* [Gleb Mazovetskiy](https://github.com/glebm)

and a [significant number of other contributors][contrib].

[converter]: https://github.com/twbs/bootstrap-sass/blob/master/tasks/converter/less_conversion.rb
[version]: https://github.com/twbs/bootstrap-sass/blob/master/lib/bootstrap-sass/version.rb
[contrib]: https://github.com/twbs/bootstrap-sass/graphs/contributors
[antirequire]: https://github.com/twbs/bootstrap-sass/issues/79#issuecomment-4428595
[jsdocs]: http://getbootstrap.com/javascript/#transitions
[sass-precision]: http://sass-lang.com/documentation/Sass/Script/Value/Number.html#precision%3D-class_method
[mincer]: https://github.com/nodeca/mincer
[autoprefixer]: https://github.com/ai/autoprefixer
