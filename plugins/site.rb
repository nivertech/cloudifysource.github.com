module Jekyll

  # Extensions to the Jekyll Site class.

  class Site

    # Regular expression by which guide pages are recognized
    DOC_PAGE_RE = /\/guide\/.*/

    # Find my blog posts among all the pages.
    def doc_pages
        self.pages.select {|p|p.full_url =~ DOC_PAGE_RE}
    end

    # Add some custom options to the site payload, accessible via the
    # "site" variable within templates.
    #
    # articles - blog articles, in reverse chronological order
    # max_recent - maximum number of recent articles to display
    alias orig_site_payload site_payload
    def site_payload
        h = orig_site_payload
        payload = h["site"]		
        payload["page_categories"] = {}
        docs_local = self.doc_pages		
        docs_local.each do |page|			
			#puts page.title
            unless payload["page_categories"].key? page.category
                payload["page_categories"][page.category] = []				
            end
            if (page.publish != nil and page.publish == true)								
                liquid_map = {"url" => page.full_url, "title" => page.title, "abstract" => page.abstract, "pageord" => page.pageord}				
                page_category = payload["page_categories"][page.category] += [liquid_map]		
			end
			#puts "------------"
        end
        payload["page_categories"].each_pair do |category, pages|		
            payload["page_categories"][category] = pages.sort {|p1, p2| p1["pageord"] <=> p2["pageord"]}
        end		
        h["site"] = payload
        h
    end

  end

end