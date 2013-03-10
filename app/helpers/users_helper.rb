# encoding: utf-8

require 'json'
require 'open-uri'
require 'uri'

module UsersHelper

	def get_directions(street_orig,street_dest)
		street_orig_uri = URI.escape(street_orig)
		street_dest_uri = URI.escape(street_dest)
		query = JSON.parse(open("http://maps.googleapis.com/maps/api/directions/json?origin=#{street_orig_uri}&destination=#{street_dest_uri}&sensor=false").read)
		roads = ["4th Line","10th Line","Airport Parkway","Albert","Albion","Alta Vista","Anderson","Aviation Parkway","Bank","Bankfield","Baseline","Bayshore","Beechwood","Blair","Booth","Boundary","Bronson","Brookfield","Cambrian","Cameron ","Campeau","Carling","Carp","Carp View","Castlefrank","Catherine","Cedarview","Century","Chamberlain","Charlotte","Clyde","Colonel By","Colonial","Conroy","Coventry","Corkstown","Craig","Dalmeny","Devine","Dilworth","Donald B Munro","Donnelly","Dunning","Dunrobin","Dwyer Hill","Eagleson","Earl Armstrong","Elgin","Fallowfield","Fernbank","Ferry","Fisher","Flewellyn","Frank Kenny","Franktown","Galetta","Gladstone","Greenbank","Gregoire","Harbour","Hawthorne","Hawthorne","Hazeldean","Hemlock","Heron","Highway 7","Hwy. 7","Hwy 7","Highland","ON-417","Hogs Back","Holly Acres","Hope","Hunt Club ","Huntley","Huntmar","Industrial","Innes ","Island Park","Jeanne d'Arc","Jockvale ","Katimavik","Kent","Kinburn","King Edward","Kirkwood","Laurier","Lees","Leitrim","Lester","Limebank","Lyon","MacKenzie","Madawaska","Main","Maitland","Manotick Main","March","Marvelville","McArthur","McBean","Meadowlands","Mer Bleue","Merivale","Metcalfe","Milton","Mitch Owens","Montreal","Moodie","Munster","Murray","Navan","John A MacDonald","Nicholas","North Gower","O'Connor","NCC Sceneic","Ogilvie","Old Montreal","Old Prescott","Orléans","Osgoode Main","Sir John A. Macdonald","Palladium","Panmure","Parkdale","Perth ","Pinecrest","Preston","Prince of Wales","Queen Elizabeth","Queensway","Ramsayville ","Regional Road 29","RR 29","R.R. 29","Regional Road 174","RR 174","R.R. 174","Hwy 174","Hwy. 174","Highway 174","Richmond","Rideau","Rideau Valley ","River","Riverside","Robertson","Rockdale","Rockcliffe","Roger Stevens","Russland","Russell","Saumure","St. Joseph","St. Laurent","St. Patrick","Scott","Slater","Smith","Smyth","Snake Island","Somerset","Sparks","Stagecoach","Stittsville","Strandherd","Sussex","Terry Fox","Timm","Thomas A. Dolan ","Thomas Argue","Trail","Tremblay","Trim","Vanier","Veterans Memorial Highway","ON-416","Victoria","Walkley","Walker","Wellington","Woodroffe Avenue"]
		result = []

		query['routes'][0]['legs'][0]['steps'].each do |step|
			check = strip_tags(step.fetch('html_instructions'))
			puts check
			roads.each do |road|
				if check.include?(road)
					result.push(road)
				end
			end
		end

		result.uniq
	end

end


