class Commit

  attr_reader :id, :message, :author, :files

  def initialize(params)
    @id = params[:id]
    @message = params[:message]
    @author = params[:author]
    @files = params[:files]
  end

  def to_s
    <<-STR
    #{@id}: #{@message} (#{@author})
    #{@files.join("\n")}
    STR
  end
end