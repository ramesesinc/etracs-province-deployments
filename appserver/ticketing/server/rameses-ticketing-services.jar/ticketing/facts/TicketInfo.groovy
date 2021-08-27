package ticketing.facts;

class TicketInfo {
	
	int numadult;
	int numchildren;
	int numsenior;

	int numfil;
	int numnonfil;

	String tag; 
	String routeid; 

	public TicketInfo( def m ) {
		this.numadult = (m.numadult ? m.numadult : 0); 
		this.numchildren = (m.numchildren ? m.numchildren : 0); 
		this.numsenior = (m.numsenior ? m.numsenior : 0); 

		this.numfil = (m.numfil ? m.numfil : 0); 
		this.numnonfil = (m.numnonfil ? m.numnonfil : 0); 

		this.tag = m.tag; 
		this.routeid = m.routeid;
	}
}