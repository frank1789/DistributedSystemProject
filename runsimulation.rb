#!/usr/local/bin/ruby -w
# encoding: utf-8

class Simulation
	attr_accessor :numrobot, :steptime, :numstep, :maplist
	def initialize
		@maplist 		= ["maptest80x80", "maptest100x100"]
		@numrobot 	= 0
		@steptime		= 0
		@numstep 		= 0
		self.setRobot
		self.setLengthTime
		#self.setMap
	end

	def setRobot
		numrobot = nil
		loop do
			puts "Insert  number of robot do you want to use in the simulation?"
			numrobot = gets.to_i
			break if numrobot >= 1
		end
		@numrobot = numrobot
	end

	def setLengthTime
		basetime = nil
		numstep = nil
		loop do
			puts "Enter the time step (second):"
			basetime = gets.to_i
			break if basetime >= 100
		end
		@steptime = basetime

		loop do
			puts "Enter the number of time steps"
			numstep = gets.to_i
			break if numstep >= 1
		end
		@numstep = numstep

		puts "a basic time of #{self.steptime} seconds will be set and increased at each iteration, then:"
		for i in 1..@numstep
			case i
			when 1
				puts "#{i}) Run #{i}st simulation with #{i * @steptime} seconds."
			when 2
				puts "#{i}) Run #{i}nd simulation with #{i * @steptime} seconds."
			when 3
				puts "#{i}) Run #{i}rd simulation with #{i * @steptime} seconds."
			else
				puts "#{i}) Run #{i}th simulation with #{i * @steptime} seconds."
			end
		end
	end

	def setMap
		i = 0
		puts "How many maps do you want to insert?"
		nummap = gets.to_i
		while i < nummap
			puts "Type the name file *.mat without extstesion"
			puts "make sure the files are in the project folder"
			text = gets
			@maplist.insert(text)
			i += 1
		end
	end
end

class MatlabLauncher
	attr_accessor :version, :option, :root, :script
	def initialize
		@version = self.setVersion
		@option = "-nodisplay -nosplash"
		@root = "/Applications/"
		@script = String.new
	end

	def setVersion
		versionfind = []
		versionselect = nil
		use = nil
		matlabdir = Dir["/Applications/MATLAB_R*"]
		if matlabdir.count > 1
			puts "find more versions MATLAB, which one to use?"
			matlabdir.each { |a|
				match = a.match(/([A-Z]\w+\_[A-Z]\w+)/)
				versionfind.push(match[0])
			}
			versionfind.each_with_index {|val, index| puts "\t#{index+1}) #{val}" }
			loop do
				puts "select one [1 to #{versionfind.count}]: "
				versionselect = gets.to_i
				if versionselect >= 1 && versionselect <= versionfind.count
					use = versionselect - 1
					break
				else
					puts "# WARNING: wrong selection"
				end
			end
		end
		return versionfind[use].to_s + ".app/bin/"
	end

	def setScript(script = "")
		@script = "matlab " + @option + " -r \"run #{script};exit;\""
	end

	def launch
		command = String.new
		command = @root + @version + @script
		puts command
		return command
	end
end

if __FILE__ == $PROGRAM_NAME
	result = File.open('Report/result.txt', 'w')
	header = "%7s\t %10s\t %7s\t %10s\t %10s\t %10s\n" % ['Test', 'num. Robot', 'Time', 'Dist', 'Map size', 'Total Cost']
	result.write(header)
	result.close

	numtest = 0
	matlab = MatlabLauncher.new
	loop do
		puts "Enter the test number for each combination?"
		numtest = gets.to_i
		numtest > 1 ? numtest : 1
		break if numtest >= 1
	end
	job = Simulation.new
	job.maplist.each do |map|
		for runtime in 1..job.numstep
			for runtest in 1..numtest
				for nrobot in 1..job.numrobot
					print "Run simulation #{runtest} of #{numtest}\n"
					print "set paramters:"
					print "\t map: #{map}"
					print "\t n.robot: #{job.numrobot}"
					print "\t time: #{runtime * job.steptime}\n"
					matlab.setScript("clear;load('#{map}.mat');addpath('Utility-Mapping');compilemexlibrary;multirobot(#{nrobot}, #{runtime * job.steptime}, map,#{runtest})")
					command = Thread.new do
						system(matlab.launch) # long-long programm
					end
					command.join              # main programm waiting for thread
					puts "complete"
				end
			end
		end
	end
end
