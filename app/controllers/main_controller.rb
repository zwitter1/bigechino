class MainController < ApplicationController
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
	   else if page == "search"
	   	search(start, data, count)
	   end
	   
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
	   else if page == "search"
	   	search(start, data, count,go)
	   end
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
		if data == nil or data.length == 0
			inData = params['data']
		else
			inData = data
		end
		puts "pre where clause"
		whereclause = whereparams(inData)
		results = nil 
		puts "post where clause"
		# run the queries based on weather or not parameters were passed	
		if whereclause != nil
			puts "Attempting query"
			results = Sequence.joins(:Foreigndb,:Goterm,:Taxa).select(:header,:taxaclass, :genus, :interpro_desc,:description,:dbname, :read_depth, :name).where(*whereclause).limit(count).offset(starting)#.distinct
			puts "post query"
		else
			results = Sequence.joins(:Foreigndb,:Goterm,:Taxa).select(:header,:taxaclass, :genus, :interpro_desc,:description,:dbname, :read_depth, :name).limit(count).offset(starting).distinct	
		end	  
		
		retStr = "<table><tr><th>Header</th><th>Taxon</th><th>Amino Sequence</th><th>Coding Sequence</th><th>Nucleotide Sequence</th><th>Description</th><th>Read Depth</th><th>Go Reduction</th>" 
		puts "building results"  
		#binding.pry
		for accession in results
	    	retStr += "<tr><td>#{accession.header}</td><td>#{accession.genus}</td><td class='sequence'><div class='scrollable'>#{accession.protein_sequence}</div></td><td class='sequence'><div class='scrollable'>#{accession.coding_sequence}</div></td><td class='sequence'><div class='scrollable'>#{accession.raw_nucleotide}</div></td><td>#{accession.interpro_desc}</td><td>#{accession.read_depth}</td><td>#{accession.name}</td></tr>"
	    end
		puts "returning"
		#binding.pry
		retStr += "</table>"
		render html: retStr.html_safe
		
		 
	end	
   
   
   def evaluate 
	 	puts "evaluating..."
	    data =  params['data']
	    checked = params['checked']
	    go = params['go']
	    count = params['count']
	    binding.pry
	    if checked == 'search'
		   search(0,data,count,checked) 
		end
	    
	    
   end
   
   
   
   # taxon, readD, go
   def whereparams(input)
	   param = []
	   whereStr = ''
	   
	   pos = 0
	   for i in input
		   if pos == 0
		   		if i.length > 0 
			   		whereStr << "taxaclass LIKE ? AND "
				end
		   end
		   if pos == 1
		   		if i.length > 0  
			   		whereStr << "read_depth = ? AND "
				end
		   end
		   if pos == 2
		   		if i.length > 0 
			   		whereStr << "name LIKE ? AND "
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
			 if pos == 1
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
