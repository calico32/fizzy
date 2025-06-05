module CollectionsHelper
  def collection_auto_close_options
    [
      [ "3", 3.days ],
      [ "7", 7.days ],
      [ "11", 11.days ],
      [ "30", 30.days ],
      [ "90", 90.days ],
      [ "365", 365.days ]
    ]
  end

  def collection_stalled_options
    [
      [ "1 day", 1.days ],
      [ "2 days", 2.days ],
      [ "3 days", 3.days ],
      [ "7 days", 7.days ],
      [ "14 days", 14.days ],
      [ "30 days", 30.days ],
      [ "365 days", 365.days ]
    ]
  end
end
