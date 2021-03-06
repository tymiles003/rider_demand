require 'rails_helper'

RSpec.describe Event, type: :model do
  context ".categories" do
    VCR.use_cassette("event_spec/categories") do
      categories = Event.categories

      it "returns categories" do
        expect(categories.count).to eq(29)
      end

      it "a category has a name" do
        expect(categories.first["name"]).to eq("Concerts & Tour Dates")
      end
    end
  end

  context ".category_names_and_ids" do
    VCR.use_cassette("event_spec/category_names") do
      names = Event.category_names_and_ids

      it "returns 'All' first" do
        expect(names.first).to eq(["All", ""])
      end

      it "returns a name and id" do
        expect(names[1]).to eq(["Concerts & Tour Dates", "music"])
      end
    end
  end

  context ".where" do
    context "with default options" do
      VCR.use_cassette("event_spec/events_with_date_override") do
        options = { date: "2015031000-2015031000" }
        events = Event.where(options)
        event = events.first

        it "returns events" do
          expect(events.count).to eq(100)
          expect(event.class).to eq(Event)
        end

        context "#format_time" do
          it "returns a formatted time with a valid time given" do
            expect(event.format_time(event.start_time)).to eq(" 9:00 pm")
          end

          it "returns 'unspecified' with not time given" do
            expect(event.format_time(nil)).to eq("unspecified")
          end
        end

        it "#title" do
          expect(event.title).to eq("The Reggae Room")
        end

        it "#categories" do
          expect(event.categories).to eq(["Nightlife &amp; Singles"])
        end

        it "#format_time" do
          expect(event.format_time(event.start_time)).to eq(" 9:00 pm")
        end

        it "#time_range" do
          expect(event.time_range).to eq(" 9:00 pm -  2:00 am")
        end

        it "#all_day?" do
          expect(event.all_day?).to eq(false)
        end

        it "#latitude" do
          expect(event.latitude.class).to eq(Float)
        end

        it "#longitude" do
          expect(event.longitude.class).to eq(Float)
        end

        it "#start_date" do
          expect(event.start_date).to eq("1/8/15")
        end

        it "#end_date" do
          expect(event.end_date).to eq("10/2/15")
        end

        it "#date_range" do
          expect(event.date_range).to eq("1/8/15 - 10/2/15")
        end
      end
    end
  end

  context "with multiple options" do
    VCR.use_cassette("event_spec/events_with_overrides") do
      options = { date: "2015031000-2015031000",
                  location: "San Francisco" }
      event = Event.where(options).first

      it "has a title" do
        expect(event.title).to eq("Mat Kearney")
      end
    end
  end
end
