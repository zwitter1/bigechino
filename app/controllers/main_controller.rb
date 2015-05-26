class MainController < ApplicationController
  def browse
	  render layout: false 
  end
  
  def primary 
	  render "browse"
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
	   
	   if page == 'sequence'
	   	seq(start)
	   else if page == "search"
	   	search(start, data)
	   end
	   
    end
    end
   
   def ppage
	   start = params['stTime']
	   page = params['page']
	   data = params['data']
	   
	   if page == 'sequence'
	   	seq(start)
	   else if page == "search"
	   	search(start, data)
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
   
   
   
   def search(starting = 0, data = nil)
	    indata = nil
		if data == nil or data.length == 0
			inData = params['data']
		else
			inData = data
		end
		whereclause = whereparams(inData)
		results = nil 
		
		# run the queries based on weather or not parameters were passed	
		if whereclause != nil
			results = Sequence.joins(:Foreigndb,:Goterm,:Taxa).select(:header, :taxaclass, :protein_sequence, :coding_sequence, :raw_nucleotide, :interpro_desc, :read_depth, :name).where(*whereclause).limit(1000).offset(starting).distinct
		else
		results = Sequence.joins(:Foreigndb,:Goterm,:Taxa).select(:header, :taxaclass, :protein_sequence, :coding_sequence, :raw_nucleotide, :interpro_desc, :read_depth, :name).limit(1000).offset(starting).distinct	
		end	  
		
		retStr = "<table><tr><th>Header</th><th>Taxon</th><th>Amino Sequence</th><th>Coding Sequence</th><th>Nucleotide Sequence</th><th>Description</th><th>Read Depth</th><th>Go Reduction</th>" 
		  
		for accession in results
	    	retStr += "<tr><td>#{accession.header}</td><td>#{accession.taxaclass}</td><td class='sequence'><div class='scrollable'>#{accession.protein_sequence}</div></td><td class='sequence'><div class='scrollable'>#{accession.coding_sequence}</div></td><td class='sequence'><div class='scrollable'>#{accession.raw_nucleotide}</div></td><td><div class='scrollable'>#{accession.interpro_desc}</div></td><td>#{accession.read_depth}</td><td>#{accession.name}</td></tr>"
	    end
	 
	  retStr += "</table>"
	  render html: retStr.html_safe
		
		 
	end	
   
   # taxon, description, readD, go
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
			   		whereStr << "interpro_desc LIKE ? AND "
				end
		   end
		   if pos == 2
		   		if i.length > 0  
			   		whereStr << "read_depth LIKE ? AND "
				end
		   end
		   if pos == 3
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
	   for i in input
		  if i.length > 0
			 empty = false  
			 buildString = '%#{i}%'
			 param << buildString
		  end  
	   end
	   
	   if empty 
		  return nil
	   else 
	   	  return param 
	   end
   end   
  
end
