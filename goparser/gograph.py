class gograph:
    def __init__(self):
        #
        self.idIndex = {}

    def addKey(self,key):
        self.idIndex[key] = []

    def addValue(self, key, value):
        if key in self.idIndex:
            existinglist = self.idIndex[key]
            if value not in existinglist:
                existinglist.append(value)
            self.idIndex[key] =  existinglist
        else:
            self.idIndex[key] = [value]

        if value in self.idIndex:
            return
        else:
            self.addKey(key)
