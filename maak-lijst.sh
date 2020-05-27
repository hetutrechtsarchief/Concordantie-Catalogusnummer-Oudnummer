# zie readme.md

output_base=output/HUA-catnr-oudnr

echo "Catalogusnummer,Oudnummer" > $output_base.csv

for i in `seq 0 10000 120000`
do 
  curl https://data.netwerkdigitaalerfgoed.nl/_api/datasets/hetutrechtsarchief/mi2rdf/services/mi2rdf/sparql -X POST --data 'query=PREFIX%20xsd%3A%20%3Chttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%3E%0APREFIX%20rdf%3A%20%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0APREFIX%20rdfs%3A%20%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0APREFIX%20soort%3A%20%3Chttps%3A%2F%2Farchief.io%2Fsoort%23%3E%0APREFIX%20v%3A%20%3Chttps%3A%2F%2Farchief.io%2Fveld%23%3E%0A%0ASELECT%20%20%3FCatalogusnummer%2C%20%3Foudnummer%20WHERE%20%7B%20%20%23%20subselect%20voor%20ORDER%20BY%20icm%20OFFSET%0A%20%20SELECT%20%3FCatalogusnummer%2C%20%3Foudnummer%20%20%7B%0A%20%20%20%20%7B%20%3Fsub%20v%3Anummer%20%3FCatalogusnummer%20%3B%20v%3Aoudnummer_1%20%3F_oudnummer%7D%0A%20%20%20%20UNION%0A%20%20%20%20%7B%20%3Fsub%20v%3Anummer%20%3FCatalogusnummer%20%3B%20v%3Aoudnummer_2%20%3F_oudnummer%7D%20%0A%20%20%20%20UNION%0A%20%20%20%20%7B%20%3Fsub%20v%3Anummer%20%3FCatalogusnummer%20%3B%20v%3Aoudnummer_3%20%3F_oudnummer%7D%0A%20%20%20%20BIND%28REPLACE%28%3F_oudnummer%2C%22%5Cn%22%2C%22%22%29%20as%20%3Foudnummer%29%20%23%20remove%20linefeed%20from%20%3F_oudnumber%0A%20%20%7D%0A%20%20ORDER%20BY%20%3Foudnummer%0A%7D%0A%0ALIMIT%2010000%0AOFFSET%200'$i \
   -H "Accept: text/csv" | awk 'FNR>1' >> $output_base.csv # zorgt dat de header telkens worden weggefilterd
done

#convert to Markdown
csv2md $output_base.csv > $output_base.md  

#convert to HTML
marked $output_base.md > $output_base.html 

# Convert to PDF
markdown-pdf $output_base.md 