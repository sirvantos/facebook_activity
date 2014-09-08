module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Nouscourse"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  #google map
  def render_info_window data_object
    render_to_string(:partial => "/share/maps/google/infowindow",
                     :locals => { info_window: data_source_2_info_window(data_object)})
  end

  private

  def data_source_2_info_window data_object
    data_source = {}
    if data_object.instance_of?(User)
      data_source = {
          title: data_object.name,
          image: {href: data_object.image, alt: data_object.name},
          description: 'You here'
      }
    else
      data_source = data_object
    end

    data_source
  end
end
