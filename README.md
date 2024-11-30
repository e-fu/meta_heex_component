# PhoenixLiveMeta

A Phoenix library for dynamic meta tag management with LiveView support.

## Features

- Dynamic meta tag management for SEO
- Open Graph and Twitter Card support
- LiveView and controller integration
- Customizable defaults
- Additional meta tag support

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `phoenix_live_meta` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:phoenix_live_meta, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/phoenix_live_meta>.

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


## Example integration in root.html.heex:
```elixir
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <.live_meta_tags
    meta_description={@meta_description}
    meta_keywords={@meta_keywords}
    author={@author}
    og_title={@og_title}
    og_image={@og_image}
    twitter_site="@yourapplication"
    additional_meta_tags={[
      %{name: "application-name", content: "Your App"}
    ]}
  />
</head>
```

### The End
