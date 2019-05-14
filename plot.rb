class Plot
	def self.plot(x, y, title, lines:'lines', width:4, minX:y.min, maxX:y.max)
		Gnuplot.open do |gp|
			Gnuplot::Plot.new( gp ) do |plot|

				plot.xrange "[#{minX.to_i}:#{maxX.to_i}]"
				plot.title  title
				# plot.ylabel "x"
				# plot.xlabel ""
				plot.data << Gnuplot::DataSet.new([x,y]) do |ds|
					ds.with = lines
					ds.linewidth = width
				end
			end
		end
	end
	def self.plot_array(data, title, lines:'lines', width:4)
		Gnuplot.open do |gp|
			Gnuplot::Plot.new( gp ) do |plot|
				# plot.xrange "[#{minX.to_i}:#{maxX.to_i}]"
				plot.title title
				# plot.ylabel "x"
				# plot.xlabel "sin(x)"\
				data.each do |item|
					plot.data << Gnuplot::DataSet.new([item[:x],item[:y]]) do |ds|
						ds.with = lines
						ds.linewidth = width
						ds.title = item[:title]
					end
				end
			end
		end
	end
end