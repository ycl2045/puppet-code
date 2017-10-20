require 'mcollective/agent/shell/job'

module MCollective
  module Agent
    class Shell<RPC::Agent
      action 'run' do
        run_command(request.data)
      end

      action 'start' do
        start_command(request.data)
      end

      action 'status' do
        handle = request[:handle]
        process = Job.new(handle)
        stdout_offset = request[:stdout_offset] || 0
        stderr_offset = request[:stderr_offset] || 0

        reply[:status] = process.status
        reply[:stdout] = process.stdout(stdout_offset)
        reply[:stderr] = process.stderr(stderr_offset)
        if process.status == :stopped
          reply[:exitcode] = process.exitcode
        end
      end

      action 'kill' do
        handle = request[:handle]
        job = Job.new(handle)

        job.kill
      end

      action 'list' do
        list
      end

      private

      def run_command(request = {})
        process = Job.new
        if request[:type] == 'cmd' or request[:type].nil?
          process.start_command(request[:command])
        elsif request[:type] == 'script'
          require 'tempfile'
          tmpfile = Tempfile.new(request[:filename])
          if request[:base64] == true
            content = Base64.decode64(request[:content])
          else
            content = request[:content]
          end
          tmpfile.write(content)
          tmpfile.close
          system("chmod 755 #{tmpfile.path}")
Log.info("command:su - #{request[:user]} -c '" + tmpfile.path + " \"" + request[:params].to_s.gsub('"','\\"') + "\"'")
	  if request[:params].to_s.include? "master"
		process.start_command("su - #{request[:user]} -c '" + tmpfile.path + " \"" + request[:params].to_s.gsub('"','\\"') + "\"'")
	  else
          	process.start_command("su - #{request[:user]} -c '" + tmpfile.path + " " + request[:params].to_s + "'")
          end
        end
        timeout = request[:timeout] || 0
        reply[:success] = true
        begin
          Timeout::timeout(timeout) do
            process.wait_for_process
          end
        rescue Timeout::Error
          reply[:success] = false
          process.kill
        end

        reply[:stdout] = process.stdout
        reply[:stderr] = process.stderr
        reply[:exitcode] = process.exitcode
        process.cleanup_state
      end

      def start_command(request = {})
        job = Job.new
        if request[:type] == 'cmd'
          job.start_command(request[:command])
        elsif request[:type] == 'script'
          require 'tempfile'
          tmpfile = Tempfile.new(request[:filename])
          if request[:base64] == true
            content = Base64.decode64(request[:content])
          else
            content = request[:content]
          end
          tmpfile.write(content)
          tmpfile.close
          system("chmod 700 #{tmpfile.path}")
          job.start_command(tmpfile.path)
        end
        reply[:handle] = job.handle
      end

      def list
        list = {}
        Job.list.each do |job|
          list[job.handle] = {
            :id      => job.handle,
            :command => job.command,
            :status  => job.status,
            :signal  => job.signal,
          }
        end

        reply[:jobs] = list
      end
    end
  end
end
