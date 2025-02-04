function begin()
    obicontext.item("compteur",0)
end

function worker(sequence)
    taxonomy = Taxonomy.default()
    taxid = sequence:attribute("family_taxid")
    taxon = taxonomy:taxon(taxid)
    print(taxon:string())
    sequence:attribute("family_taxid",taxon:string())
    sequence:attribute("toto",44444)
    nb = obicontext.inc("compteur")
    sequence:id("seq_" .. nb)
    return sequence
end

function finish()
    print("compteur = " .. obicontext.item("compteur"))
end
	