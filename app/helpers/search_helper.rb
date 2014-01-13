module SearchHelper
  def display_highlight(hls)
    hl_arr = []
    hls.each do |hl|
      hl_arr << (hl.format { |word| "<strong>#{word}</strong>" })
    end
    hl_arr.join('')
  end
end
