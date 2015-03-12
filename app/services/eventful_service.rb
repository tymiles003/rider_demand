class EventfulService
  include HTTParty
  base_uri "http://api.eventful.com/json"

  def events(overrides = {})
    events = JSON.parse(self.class.get("/events/search", query: overridden_options(overrides)))
    events["events"]["event"]
  end

  def categories
    parse_categories(self.class.get("/categories/list", query: category_options))
  end

  private

  def default_event_options
    { app_key: ENV["EVENTFUL_KEY"],
      location: "39.7392, -104.9903",
      within: 20,
      units: "mi",
      include: "categories",
      mature: "normal",
      sort_order: "date",
      sort_direction: "ascending",
      page_size: 100,
      date: "Today" }
  end

  def category_options
    { app_key: ENV["EVENTFUL_KEY"] }
  end

  def overridden_options(overrides)
    default_event_options.update(overrides)
  end

  def parse_categories(categories)
    JSON.parse(categories)["category"].each do |category|
      category["name"].gsub!("amp;", "")
    end
  end
end