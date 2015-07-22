import sys
from gograph import gograph

index = {}


def main(input):
    loadGo()
    global index
    result = buildJsonTree(input.split("-"))
    # write result to file
    f = open('public/go.json','w')
    print "YE"
    f.write(result) # python will convert \n to os.linesep
    f.close()


# the buildJsonTree function should take a list of all the go terms that
# you would like to build the tree out of and build a json formatted output
# for visuzlization in a d3 base treeMap
def buildJsonTree(inTerms):
    # build the graph that will house the top down data seen in the provided terms
    graph = gograph()
    # iterate through all of the terms and trace them back to their roots
    # while running this trace be sure to add the seen values to the gograph
    for term in inTerms:
        #print 'starting with: ' + term + '\n\n'
        runTrace(term,graph)
    #code.interact(local=locals())
    #Assume that the roots are used.
    roots = ['0008150','0005575','0003674']
    result = '{"name":"Go Data","children":['

    for i in roots:
        if i in graph.idIndex:
            result = result + toJson(i,graph,'')
            result = result + ','

    return result.rsplit(',', 1)[0] + ']}'
# toJson is the recursive function that builds from the input source term down
# to the leaves
def toJson(term, graph, result):
        global index
        name = index[int(term.lstrip("0"))]["name"]
        children = graph.idIndex[term]

        if len(children) > 0:
            result = result + '{ "name":"' + name + '", "children":['

            for child in children:
                result = toJson(child, graph, result)
                if child != children[-1]:
                    result = result + ','


            result = result + ']}'

        else:
            result = result + '{ "name":"' + name + '", "value":1000}'

        return result

# runTrace will be a recursive function to trace the given goterm to it's root.
# While tracing it will alson be storing data into the gograph to later allow
# us to build a top down json structure of what the Go specification looks
# like provided the given terms.
def runTrace(term, graph):
    place = term.lstrip('0')

    global index
    data = index[int(place)]

    # current Id of the data being handled
    goId = data.get('id')

    # this part gets tricky. We need to get all of the 'is_a' relationships
    # within the current object, add it to the gograph and the recursively
    # call upon it.
    searchString = 'is_a'

    nextList = []
    count = 0
    while searchString in data:
        count = count + 1
        parent = data.get(searchString).split('!')[0].strip()
        #print 'added: ' + parent + ' - ' + goId + '\n'
        graph.addValue(parent, goId)
        nextList.append(parent)
        if count > 0:
            searchString = 'is_a' + str(count)

    for ancestor in nextList:
        #print 'exploring: ' + ancestor + '\n'
        runTrace(ancestor,graph)

def loadGo():
    global index
    record = False
    currentObj = {}
    curLine = 0
    with open('goparser/go-basic.obo.txt') as f:

        for line in f:
            line = line.strip('\n')
            curLine = curLine + 1
            if (line == '[Typedef]'):
                record = False
                continue

            if( line == '[Term]' ):
                record = True
                continue

            if( record == False):
                continue

            if line == '':
                #code.interact(local=locals())
                place = int(currentObj.get('id').lstrip('0'))
                index[place] = currentObj
                currentObj = {}
                continue

            splitline = line.split(':')
            currentKey = splitline[0]
            currentVal = ''

            if currentKey == 'id' or currentKey == 'is_a':
                #print curLine
                #print splitline
                currentVal = splitline[2]
            else:
                #print splitline
                currentVal = splitline[1]


            if currentKey in currentObj:
                recur = 1
                original = currentKey
                currentKey = currentKey + str(recur)
                while currentKey in currentObj:
                    recur = recur + 1
                    currentKey = original + str(recur)

            currentObj[currentKey] = currentVal






if __name__ == '__main__':
    main(sys.argv[1])
