class MainController < ApplicationController
  $dwnldfile = ""

  def browse
	  redirect_to '/'
  end
  
  def primary 
	  loggedIn = session[:loggedIn]
	  
	  if(loggedIn == true)	
		render "browse"
	  else
		redirect_to '/'
	  end
  end 
  
  def desc(starting = 0)
	 # make calls to the database to retrieve relevant tables per Ron's query
	 
	 retStr = "<table><tr><th>Header</th><th>ID</th><th>Description</th></tr>"
	 #Foreign_link.joins(:Foreigndb).select(:header, :id, :description).find_each do |accession|
	 #	retStr += "<tr><td>#{accession.header}</td><td>#{accession.id}</td><td>#{accession.description}</td></tr>"
	 #end
	 
	 
	 results = Foreign_link.joins(:Foreigndb).select(:header, :id, :description).limit(1000).offset(starting)
	 
	 for accession in results
		 retStr += "<tr><td>#{accession.header}</td><td>#{accession.id}</td><td>#{accession.description}</td></tr>"
	 end
	 
	 retStr += "</table>"
	 render html: retStr.html_safe
  end
  
  def seq(starting = 0)
	  retStr = "<table><tr><th>Header</th><th>Protein Sequence</th><th>Coding Sequence</th><th>Raw Nucleotide</th></tr>"
	  
	  
	   results = Sequence.select(:header, :protein_sequence, :coding_sequence, :raw_nucleotide).limit(1000).offset(starting)
	 
	  for accession in results
	    	 retStr += "<tr><td>#{accession.header}</td><td class='sequence'>#{accession.protein_sequence}</td><td class='sequence'>#{accession.coding_sequence}</td><td class='sequence'>#{accession.raw_nucleotide}</td></tr>"
	  end
	 
	  retStr += "</table>"
	  render html: retStr.html_safe

	  
   end
   
   def npage
	   start = params['stTime']
	   page = params['page']
	   data = params['data']
	   count = params['count']
	   go = params['go']
	   
	   if page == 'sequence'
	   	seq(start)
	   elsif page == "search"
	   	search(start, data, count,go)
	   end
	   
  
    end
   
   def ppage
	   start = params['stTime']
	   page = params['page']
	   data = params['data']
	   count = params['count']
	   go = params['go']
	   
	   if page == 'sequence'
	   	seq(start)
	   elsif page == "search"
	   	search(start, data, count,go)
	   end
   end
   
   
   def holes
	   results = Sequence.select(:header,:protein_sequence, :coding_sequence, :raw_nucleotide).where("raw_nucleotide is NULL or coding_sequence is NULL").limit(1000)
	   
	   retStr = "<table><tr><th>header</th><th>aa seq</th><th>coding seq</th><th>prot seq</th></tr>"
	   for accession in results
			   retStr += "<tr><td>#{accession.header}</td><td><div class='scrollable'>#{accession.protein_sequence}</div></td><td><div class='scrollable'>#{accession.coding_sequence}</div></td><td><div class='scrollable'>#{accession.raw_nucleotide}</div></td></tr>"
		end
		retStr += "</table>"
		
		render html: retStr.html_safe
   end 
   
   
   
   def search(starting = 0, data = nil, count = 10,go)
	    indata = nil
	    if params['count'].length > 0 
			count = params['count'].to_i 
	    end
	    # built for if search was called directly...
		if data == nil or data.length == 0
			inData = params['data']
		# This is how this function will typically work as it is called from evaluate
		else
			inData = data
		end
		
		if count == ""
			count = 10
		end
		puts "pre where clause"
		whereclause = whereparams(inData)
		results = nil 
		puts "post where clause"
		retStr = ''
		#binding.pry
		# need to decide whether or not I am makind a join on the go table. 
		if go == 'true'
			# include go in the returned results which will make for some repeated result sets
			if whereclause != nil
				puts "Attempting query"
				results = Sequence.joins(:Foreigndb,:Goterm,:Taxa).select(:header,:taxaclass, :genus, :interpro_desc,:description,:dbname, :read_depth, :name).where(*whereclause).limit(count).offset(starting).distinct
				puts "post query"
			else
				results = Sequence.joins(:Foreigndb,:Goterm,:Taxa).select(:header,:taxaclass, :genus, :interpro_desc,:description,:dbname, :read_depth, :name).limit(count).offset(starting).distinct	
			end	 
		
		
			retStr = "<table><tr><th>Header</th><th>Class</th><th>Genus</th><th>Interpro Desc.</th><th>Alternate Description</th><th>Read Depth</th><th>Go Reduction</th>" 
			puts "building results"  
			#binding.pry
			for accession in results
				retStr += "<tr><td>#{accession.header}</td><td>#{accession.taxaclass}</td><td class='sequence'>#{accession.genus}</td><td class='sequence'>#{accession.interpro_desc}</td><td class='sequence'>#{accession.dbname}:#{accession.description}</td><td>#{accession.read_depth}</td><td>#{accession.name}</td></tr>"
			end
		
		else
			#exclude go which will strip down the result set
			if whereclause != nil
				puts "Attempting query"
				results = Sequence.joins(:Foreigndb,:Taxa).select(:header,:taxaclass, :genus, :interpro_desc,:description,:dbname, :read_depth).where(*whereclause).limit(count).offset(starting).distinct
				puts "post query"
			else
				results = Sequence.joins(:Foreigndb,:Taxa).select(:header,:taxaclass, :genus, :interpro_desc,:description,:dbname, :read_depth).limit(count).offset(starting).distinct	
			end	 
		
			retStr = "<table><tr><th>Header</th><th>Class</th><th>Genus</th><th>Interpro Desc.</th><th>Alternate Description</th><th>Read Depth</th>"  
			puts "building results"  
			#binding.pry
			for accession in results
				retStr += "<tr><td>#{accession.header}</td><td>#{accession.taxaclass}</td><td class='sequence'>#{accession.genus}</td><td class='sequence'>#{accession.interpro_desc}</td><td class='sequence'>#{accession.dbname}:#{accession.description}</td><td>#{accession.read_depth}</td></tr>"
			end
		end
		 
		
		
		puts "returning"
		#binding.pry
		retStr += "</table>"
		
		json = {:file => 0, :html => retStr.html_safe}
		render :json => json
		#render html: retStr.html_safe
		
		
		 
	end	
   
   def getFiles
		puts "pulling files"
		puts $dwnldfile
		send_file $dwnldfile #@dwnldfile
   end
   
   def aminofasta(data = nil)
		puts "building amino fasta"
		
		results = nil
		whereclause = whereparams(data)
		
		if whereclause != nil
			puts "Attempting query"
			results = Sequence.joins(:Foreigndb,:Taxa).select(:header,:taxaclass, :genus, :protein_sequence, :read_depth).where(*whereclause).limit(1000).distinct
			puts "post query"
		else
			results = Sequence.joins(:Foreigndb,:Taxa).select(:header,:taxaclass, :genus, :protein_sequence, :read_depth).limit(1000).distinct	
		end	 
		
		f = File.new("amino.fasta","w")
		
		for accession in results
			
			realheader = accession.header.sub("|",".")
			f.write(">#{realheader}.#{accession.taxaclass}.#{accession.genus}.#{accession.read_depth}\n#{accession.protein_sequence}\n")
		end
		
		f.close
		$dwnldfile = "./amino.fasta"
		
		puts @dwnldfile
		
		json = {:file => 1, :name => "amino.fasta"}.to_json
		render :json => json
   end
   
   def codingfasta(data = nil)
		puts "building coding fasta"
		results = nil
		whereclause = whereparams(data)
		
		if whereclause != nil
			puts "Attempting query"
			results = Sequence.joins(:Foreigndb,:Taxa).select(:header,:taxaclass, :genus, :coding_sequence, :read_depth).where(*whereclause).limit(1000).distinct
			puts "post query"
		else
			results = Sequence.joins(:Foreigndb,:Taxa).select(:header,:taxaclass, :genus, :coding_sequence, :read_depth).limit(1000).distinct	
		end	 
		
		
		f = File.new("coding.fasta","w")
		
		for accession in results
			realheader = accession.header.sub("|",".")
			f.write(">#{realheader}.#{accession.taxaclass}.#{accession.genus}.#{accession.read_depth}\n#{accession.coding_sequence}\n")
		end
		
		f.close
		$dwnldfile = "./coding.fasta"
		
		puts @dwnldfile
		
		json = {:file => 1, :name => "coding.fasta"}.to_json
		render :json => json
   end
   
   def nucfasta(data = nil)
		puts "building nucleotide fasta"
		results = nil
		whereclause = whereparams(data)
		
		if whereclause != nil
			puts "Attempting query"
			results = Sequence.joins(:Foreigndb,:Taxa).select(:header,:taxaclass, :genus, :raw_nucleotide, :read_depth).where(*whereclause).limit(1000).distinct
			puts "post query"
		else
			results = Sequence.joins(:Foreigndb,:Taxa).select(:header,:taxaclass, :genus, :raw_nucleotide, :read_depth).limit(1000).distinct	
		end	 
		
		
		f = File.new("nucleotides.fasta","w")
		
		for accession in results
			realheader = accession.header.sub("|",".")
			f.write(">#{realheader}.#{accession.taxaclass}.#{accession.genus}.#{accession.read_depth}\n#{accession.raw_nucleotide}\n")
		end
		
		f.close
		$dwnldfile = "./nucleotides.fasta"
		
		puts @dwnldfile
		
		json = {:file => 1, :name => "nucleotides.fasta"}.to_json
		render :json => json
   end
   
   
   def evaluate 
	 	puts "evaluating..."
	 	# data values that are relevant
	    data =  params['data']
	    # am I running a search or generating a fasta file
	    checked = params['checked']
	    # true false
	    go = params['go']
	    # int displaying how many to show
	    count = params['count']
	    #binding.pry
	    if checked == 'search'
		   search(0,data,count,go) 
		elsif checked == 'amino'
			aminofasta(data)
		elsif checked == 'coding'
			codingfasta(data)
		elsif checked == 'nucleotide'   
			nucfasta(data)
		end
	    
	    
   end
   
   
   
   # taxon, readD, go
   def whereparams(input)
	   param = []
	   whereStr = ''
	   
	   #[taxclass, taxon,readSD,readED, go, desc]	
	   
	   pos = 0
	   for i in input
		   if pos == 0
		   		if i.length > 0 
			   		whereStr << "taxaclass = ? AND "
				end
		   end
		   if pos == 1
		   		if i.length > 0  
			   		whereStr << "genus = ? AND "
				end
		   end
		   if pos == 2
		   		if i.length > 0 
			   		whereStr << "read_depth > ? AND "
				end
		   end
		   if pos == 3
		   		if i.length > 0 
			   		whereStr << "read_depth < ? AND "
				end
		   end
		   if pos == 4
		   		if i.length > 0 
			   		whereStr << "name LIKE ? AND "
				end
		   end
		   if pos == 5
		   		if i.length > 0 
			   		whereStr << "((interpro_desc LIKE ?) OR (description LIKE ?)) AND "
				end
		   end
		   pos = pos + 1
	   end 
	   
	   #len = whereStr.length - 4
	   #binding.pry
	   #whereStr = whereStr[0..len]
		   
	   whereStr.chomp!(" AND ")
	   
	   
	   param << whereStr
	   
	   empty = true
	   pos = 0
	   for val in input
		  if val.length > 0
			 empty = false  
			 puts "my input parameter is: #{val}"
			 if pos < 4
				buildString = "#{val}"
			 else
				buildString = "%#{val}%"
			 end
			 param << buildString
		  end 
		  pos = pos + 1 
	   end
	   #binding.pry
	   if empty 
		  return nil
	   else 
	   	  return param 
	   end
   end   

end
