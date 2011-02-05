atom_feed :language => 'de-AT' do |feed|
  feed.title "Schandflecken at #{@incident_report.latitude}/#{@incident_report.longitude}"
  feed.updated @updated

  @incident_report.comments.each do |item|
    next if item.updated_at.blank?

    feed.entry(item, :url => incident_report_comment_url(item.incident_report, item)) do |entry|
      entry.url incident_report_comment_url(item.incident_report, item)
      entry.title "Comment"
      entry.content item.body, :type => 'text'

      # the strftime is needed to work with Google Reader.
      entry.updated(item.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")) 

      entry.author do |author|
        author.name item.author.nil? ? "anonymous" : item.author.email
      end
    end
  end
end