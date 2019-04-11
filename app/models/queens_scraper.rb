class Scraper < ApplicationRecord

  def get_page
    Nokogiri::HTML(open("https//rupaulsdragrace.fandom.com/wiki/Category:Queens"))
  end

  def get_queens
    list = self.get_page.css('.tabber').last.css('.thumbimage')
    list = list.select.with_index {|_, i| i.even?}
    list[1..185].each do |q|
      I18n.enforce_available_locales = false
      fandom_url = I18n.transliterate("https://rupaulsdragrace.fandom.com/wiki/#{q.attr("title")}").split(' ').join('_').gsub(/\(.+/, '')
      doc = Nokogiri::HTML(open(url))
      drag_name = doc.css('#PageHeader > div.page-header__main > h1').text
      #trivia = doc.css('#mw-content-text > ul > li').text
      Queen.create(
                    drag_name: drag_name,
                    fandom_url: fandom_url,
                    trivia: trivia)
    end
  end

end
