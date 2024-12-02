# MetaHeexComponent

Meta tags management for Phoenix applications.

## Features

- Dynamic meta tag management for SEO
- Open Graph and Twitter Card support
- LiveView and controller integration
- Customizable defaults with fallback values
- Flexible support for additional meta tags

## Installation

Add `meta_heex_component` to your list of dependencies in `mix.exs`:


```elixir
def deps do
  [
    {:meta_heex_component, "~> 0.2.0"}
  ]
end
```

# Configuration
Configure default meta tags in your config files:

```elixir
# config/config.exs
config :meta_heex_component,
  defaults: %{
    og_type: "website",
    locale: "en",
  }
```

## Example integration in root.html.heex:

Include the meta tags in your layout, for example:

```elixir
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <MetaHeexComponent.live_meta_tags {MetaHeexComponent.get_meta_tags(assigns)} />
</head>
```

The get_meta_tags/1 helper function will:

Merge configuration defaults with explicitly set meta tags
Handle both controller and LiveView meta tags
Ensure proper precedence (explicit values override defaults)
Meta Tag Precedence
Meta tags are merged in the following order (later values override earlier ones):

1. Configuration defaults (from config.exs)
2. Assigns set directly on the socket/conn
3. Values in the meta_tags map (set via put_meta/2 or assign_meta/2)


## Example usage in a Controller:

```elixir
def index(conn, _params) do
  conn
  |> MetaHeexComponent.put_meta(
      meta_description: "Welcome to our homepage",
      og_title: "Homepage",
      locale: "es"  # This will override the default "en"
  )
  |> render("index.html")
end
```

## Example usage in LiveView:
```elixir
def mount(_params, _session, socket) do
  {:ok,
   MetaHeexComponent.assign_meta(socket,
     page_title: "Dashboard",
     meta_description: "Your dashboard overview",
     og_title: "User Dashboard",
     twitter_card: "summary",
     additional_meta_tags: [
       %{name: "robots", content: "index,follow"},
       %{property: "og:locale", content: "en_US"}
     ]
   )}
end
```

## Available Attributes
All attributes are optional and will use configured defaults (config.exs) when not provided.


### SEO Attributes
```elixir
meta_description - Primary meta description for SEO
meta_keywords - Keywords for SEO
author - Content author
robots - Robots meta tag content (like "index,follow")
```


### Open Graph Attributes
```elixir
og_title - Open Graph title
og_description - Falls back to meta_description if not provided
og_type - Type (e.g., 'website', 'article')
og_image - Image URL
og_url - URL
```


### Twitter Card Attributes
```elixir
twitter_card - Card type (e.g., 'summary_large_image')
twitter_site - @username for the website
twitter_title - Falls back to og_title if not provided
twitter_description - Falls back to og_description if not provided
twitter_image - Image URL
twitter_image_alt - Image alt text
```

### Additional Attributes
```elixir
canonical_url - Canonical URL
locale - Content language (e.g., 'en', 'es')
viewport - Viewport settings
theme_color - Theme color for browsers
csp - Content Security Policy
manifest - Web app manifest path
apple_touch_icon - Apple touch icon path
favicon - Favicon path
application_name - Application name
additional_meta_tags - List of additional meta tags
```

### Default Fallbacks
The component implements smart fallbacks:

```elixir
og_description falls back to meta_description
og_title falls back to meta_description
twitter_title falls back to og_title
twitter_description falls back to og_description
```

### Additional Meta Tags
custom additional_meta_tags (list) - List of additional meta tags in the format:

 ```elixir
additional_meta_tags: [
  %{name: "robots", content: "noindex"},
  %{property: "og:locale", content: "en_US"}
]
```

## Import into html_helper

You can also import the functionality into your html_helper in lib/your_app_web.ex for easier use across your application. Add the following:

```elixir
defmodule YourAppWeb do
  def html_helpers do
    ... other entries
    quote do
      import MetaHeexComponent
    end
  end
end
```

# License
MIT
