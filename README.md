# PhoenixLiveMeta

Meta tags management for Phoenix applications.

## Features

- Dynamic meta tag management for SEO
- Open Graph and Twitter Card support
- LiveView and controller integration
- Customizable defaults with fallback values
- Flexible support for additional meta tags

## Installation

Add `phoenix_live_meta` to your list of dependencies in `mix.exs`:


```elixir
def deps do
  [
    {:phoenix_live_meta, "~> 0.1.0"}
  ]
end
```


Configuration
Configure default meta tags in your config files:

# config/config.exs
config :phoenix_live_meta,
  defaults: %{
    og_type: "website",
    twitter_card: "summary_large_image",
    locale: "en",
    robots: "index,follow",
    viewport: "width=device-width, initial-scale=1"
  }

## Examle usage in a Controller:

```elixir
def index(conn, _params) do
  conn
  |> PhoenixLiveMeta.put_meta(
      meta_description: "Welcome to our homepage",
      og_title: "Homepage"
  )
  |> render("index.html")
end
```

## Example usage in LiveView:
```elixir
def mount(_params, _session, socket) do
  {:ok,
   PhoenixLiveMeta.assign_meta(socket,
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
meta_description - Primary meta description for SEO
meta_keywords - Keywords for SEO
author - Content author
robots - Robots meta tag content (like "index,follow")

### Open Graph Attributes
og_title - Open Graph title
og_description - Falls back to meta_description if not provided
og_type - Type (e.g., 'website', 'article')
og_image - Image URL
og_url - URL

### Twitter Card Attributes
twitter_card - Card type (e.g., 'summary_large_image')
twitter_site - @username for the website
twitter_title - Falls back to og_title if not provided
twitter_description - Falls back to og_description if not provided
twitter_image - Image URL

### Additional Attributes
canonical_url - Canonical URL
locale - Content language (e.g., 'en', 'es')
viewport - Viewport settings
additional_meta_tags - List of additional meta tags

### Default Fallbacks
The component implements smart fallbacks:

og_description falls back to meta_description
og_title falls back to meta_description
twitter_title falls back to og_title
twitter_description falls back to og_description

### Additional Meta Tags
custom additional_meta_tags (list) - List of additional meta tags in the format:

  ```elixir
  [
    %{property: "og:locale", content: "en_US"}
  ]
  ```

## Example integration in root.html.heex:

Include the meta tags in your layout, for example:

```elixir
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <PhoenixLiveMeta.live_meta_tags
    meta_description={assigns[:meta_description] || "Fallback"}
    meta_keywords={assigns[:meta_keywords] || "default, keywords"}
    author={assigns[:author] || "Default Author"}
    og_title={assigns[:og_title] || "Default OG Title"}
    og_image={assigns[:og_image] || "default_image.png"}
    twitter_site="@yourapplication"
    additional_meta_tags={[
      # add any others you want
      %{name: "application-name", content: "Your App"},
      %{property: "og:locale", content: "en_US"}
    ]}
  />
</head>
```
## Import into html_helper

You can also import the functionality into your html_helper in lib/your_app_web.ex for easier use across your application. Add the following:

```elixir
defmodule YourAppWeb do
  def html_helpers do
    ... other entries
    quote do
      import PhoenixLiveMeta
    end
  end
end
```



License
MIT


### The End
