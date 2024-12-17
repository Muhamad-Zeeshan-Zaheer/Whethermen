require 'csv' # to read and parse csv files 
require 'date' #to work with the current date
directory_path = "./" #it gives the path to the local directory 
csv_files = Dir.glob("#{directory_path}/*.csv") #it reads the files from current directory and extracts the csv's files

max_temps = [] #initialized the empty array to store max_temps from all the files 
min_temps = [] #initialized the empty array to store the min_temps from all the files
rainfal = [] #initialized the empty array to store the rainfall from all the files

csv_files.each do |file|  #iterate over each file to get the maxtemp mintemp and rainfall 
  CSV.foreach(file, headers: true) do |row| #this line is used to tell first row in each file should be treated as header
    max_temp = row['MaxTemp'] #this extract the value of maxtemp while reading data from each row in each file
    max_temps << max_temp.to_f if max_temp #this coverts the value of temperature into float because temperature can contain the point values
    min_temp = row['MinTemp'] #th is extract the value of min temperature while reading each row in each file
    min_temps << min_temp.to_f if min_temp #it converts the min temp value to float while extracting data from file
    rainfall = row['Rainfall'] #this is used to extract the data of rainfall column while reading data from each file
    rainfal << rainfall.to_f if rainfall #it is used to store the data rain fall column as an array to rainfall empty array 
  end
end




if max_temps.any? #this line checks if there is any max temperature available in array 
  total_max_temp = max_temps.sum  #this is used to find the sum of the max temperature
  total_days = max_temps.size    #this is used to find the total size of max temerature in all the files
  avg_max_temp = total_max_temp / total_days  #this is used to find the avg of total max temperaturs
  puts "Average Maximum Temperature in all files : #{avg_max_temp.round(2)}" #this will display the avg max temperature
else
  puts "No data available for maximum temperatures."
end


#same like the above because this is the extra thing that i have done 
if min_temps.any?
total_min_temp=min_temps.sum
days=min_temps.size
avg_min_temp=total_min_temp/days

puts "Average minimum Temperature in all files    #{avg_min_temp.round(2)}"
else
  puts "No data available for minimum temperatures"
end


#the will display the overall max temp min temp and rainfall from all the files 



overall_max_temp = max_temps.max
overall_min_temp = min_temps.min
overall_max_rainfall = rainfal.max
puts "The maximum temperature across all CSV files is: #{overall_max_temp}"
puts "The minimum temperature across all CSV files is: #{overall_min_temp}"
puts "The maximum rainfall across all CSV files is: #{overall_max_rainfall}"





days_per_month_by_file = {} #this hash is created to store this will store the information about each file and information of temperatore data in each file

csv_files.each do |file| #iteratig ovor each file
 
  days_per_month = Hash.new { |hash, key| hash[key] = { days: 0, max_temp_sum: 0, min_temp_sum: 0 } } #this hash is created to store the values of days max_temp_ sum and min temp sum

  CSV.foreach(file, headers: true) do |row| #same this line fro iteratiig over each row with headers is true means first row is treated as header
    month = row['Month'].to_i #extract the data of month which is given month
    max_temp = row['MaxTemp'].to_f #this will extract Max temp for each row 
    min_temp = row['MinTemp'].to_f  #this will extract min temp for each row 

    days_per_month[month][:days] += 1  #this will count the number of days in month column by incrementing 1 by 1

   
    days_per_month[month][:max_temp_sum] += max_temp # this will access the max_temp_sum and calculate the max_temp sum from each file 
    days_per_month[month][:min_temp_sum] += min_temp  # this will access the main_temp from each file and calculate the min_temp
  end

 
  days_per_month_by_file[file] = days_per_month #this reads the data month wise in every file 
end


days_per_month_by_file.each do |file, days_per_month|   
  puts "File: #{file}"
  days_per_month.each do |month, data|
    puts "Month #{month}:"
    puts " Total Days: #{data[:days]}"
    puts " Max Temp Sum: #{data[:max_temp_sum]}"
    puts " Min Temp Sum: #{data[:min_temp_sum]}"

   puts "Average max sum is #{ data[:max_temp_sum] / data[:days]} " 
   puts "Average min sum is #{data[:min_temp_sum] / data[:days]}"
  end
end



#it is used to add data to the the text fle 
output_file = "weather_summary.txt" 

File.open(output_file, "w") do |file|  
  file.puts "Hottest Day: #{overall_max_temp}°C"
  file.puts "Day with Highest Rainfall: #{overall_max_rainfall} mm"
  file.puts "-" * 40

  file.puts "Average Maximum Temperature per Month:"
  days_per_month_by_file.each do |file_name, days_per_month|
    days_per_month.each do |month, data|
      avg_max_temp = (data[:max_temp_sum] / data[:days]).round(2) 
      if avg_max_temp
        file.puts "  Month #{month}: #{avg_max_temp}°C" 
      end
    end
  end
  file.puts "-" * 30

  file.puts "Average Minimum Temperature per Month:"
  days_per_month_by_file.each do |file_name, days_per_month|
    days_per_month.each do |month, data|
      avg_min_temp = (data[:min_temp_sum] / data[:days]).round(2) if data[:days] > 0
      if avg_min_temp
        file.puts "  Month #{month}: #{avg_min_temp}°C"
      end
    end
  end
end
puts "Weather summary has been saved to #{output_file}"