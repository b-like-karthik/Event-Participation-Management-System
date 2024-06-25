import psycopg2
from config import config
from tabulate import tabulate

def fun(crsr):
	print('1 - Roll number and name of all the students who are managing the “Megaevent”')
	print('2 - Roll number and name of all the students who are managing “Megevent” as an “Secretary”')
	print('3 - Name of all the participants from the college “IITB” in “Megaevent”')
	print('4 - Name of all the colleges who have at least one participant in “Megaevent”')
	print('5 - Name of all the events which is managed by a “Secretary”')
	print('6 - Name of all the “CSE” department student volunteers of “Megaevent”')
	print('7 - Name of all the events which has at least one volunteer from “CSE”')
	print('8 - Name of the college with the largest number of participants in “Megaevent”')
	print('9 - Name of the college with largest number of participant overall')
	print('10 - Name of the department with the largest number of volunteers in all the events which has at least one participant from “IITB”')
	print('11 - implement the query-1 with other event')
	print('12 - Enter any other number to exit')
	ch=1
	while ch:
		print("\n")
		ch=int(input("Enter your choice: "))
		print("\n")
		if ch==1:
			# 1
			crsr.execute("SELECT Student.ROLL, Student.Name FROM Student INNER JOIN StudentEvent ON Student.ROLL= StudentEvent.ROLL WHERE StudentEvent.EID = ( SELECT Event.EID FROM Event WHERE Ename='Megaevent' ) ;")
			db = crsr.fetchall()
			head = ["ROLL","NAME"]
			table = tabulate(db,head,tablefmt="pretty")
			print(table)
		elif ch==2:
			# 2
			crsr.execute("SELECT Student.ROLL, Student.Name FROM Student INNER JOIN Role ON Student.RID = Role.RID INNER JOIN StudentEvent ON Student.ROLL=StudentEvent.ROLL WHERE Role.Rname = 'Secretary' and StudentEvent.EID = (SELECT Event.EID FROM Event WHERE Event.Ename= 'Megaevent');")
			db = crsr.fetchall()
			head = ["ROLL","NAME"]
			table = tabulate(db,head,tablefmt="pretty")
			print(table)
		elif ch==3:
			# 3
			crsr.execute("SELECT Participants.Name FROM Participants INNER JOIN EventParticipants ON Participants.PID = EventParticipants.PID WHERE Participants.CName = 'IITB' AND EventParticipants.EID = (SELECT Event.EID FROM Event WHERE Event.Ename = 'Megaevent');")
			db = crsr.fetchall()
			head = ["NAME"]
			table = tabulate(db,head,tablefmt="pretty")
			print(table)
		elif ch==4:
			# 4
			crsr.execute("SELECT DISTINCT Participants.CName FROM Participants INNER JOIN EventParticipants ON Participants.PID = EventParticipants.PID WHERE EventParticipants.EID = (SELECT Event.EID FROM Event WHERE Event.Ename = 'Megaevent');")
			db = crsr.fetchall()
			head = ["NAME"]
			table = tabulate(db,head,tablefmt="pretty")
			print(table)
		elif ch==5:
			# 5
			crsr.execute("SELECT Event.Ename FROM Event INNER JOIN StudentEvent ON Event.EID = StudentEvent.EID INNER JOIN Student ON StudentEvent.ROLL = Student.ROLL INNER JOIN Role ON Student.RID = Role.RID WHERE Role.Rname = 'Secretary';")
			db = crsr.fetchall()
			head = ["ENAME"]
			table = tabulate(db,head,tablefmt="pretty")
			print(table)
		elif ch==6:
			# 6
			crsr.execute("SELECT Student.Name FROM Student INNER JOIN EventVolunteer ON Student.ROLL = EventVolunteer.ROLL INNER JOIN Event ON EventVolunteer.EID = Event.EID WHERE Event.Ename = 'Megaevent' AND Student.Dept = 'CSE';")
			db = crsr.fetchall()
			head = ["NAME"]
			table = tabulate(db,head,tablefmt="pretty")
			print(table)
		elif ch==7:
			# 7
			crsr.execute("SELECT DISTINCT Event.Ename FROM Event INNER JOIN EventVolunteer ON Event.EID = EventVolunteer.EID INNER JOIN Student ON EventVolunteer.ROLL = Student.ROLL WHERE Student.Dept = 'CSE';")
			db = crsr.fetchall()
			head = ["ENAME"]
			table = tabulate(db,head,tablefmt="pretty")
			print(table)
		elif ch==8:
			# 8
			crsr.execute("SELECT Participants.CName FROM Participants INNER JOIN EventParticipants ON Participants.PID = EventParticipants.PID INNER JOIN Event ON EventParticipants.EID = Event.EID WHERE Event.Ename = 'Megaevent' GROUP BY Participants.cName ORDER BY COUNT(*) DESC LIMIT 1;")
			db = crsr.fetchall()
			head = ["CNAME"]
			table = tabulate(db,head,tablefmt="pretty")
			print(table)
		elif ch==9:
			# 9
			crsr.execute("SELECT Participants.CName FROM Participants GROUP BY Participants.cName ORDER BY COUNT(*) DESC LIMIT 1;")
			db = crsr.fetchall()
			head = ["CNAME"]
			table = tabulate(db,head,tablefmt="pretty")
			print(table)
		elif ch==10:
			# 10
			crsr.execute("SELECT Student.Dept FROM Student WHERE Student.ROLL IN ( SELECT DISTINCT EventVolunteer.ROLL FROM EventVolunteer INNER JOIN EventParticipants ON EventVolunteer.EID = EventParticipants.EID INNER JOIN Participants ON EventParticipants.PID = Participants.PID WHERE Participants.CName = 'IITB' ) GROUP BY Student.Dept ORDER BY COUNT(*) DESC LIMIT 1;")
			db = crsr.fetchall()
			head = ["DEPT NAME"]
			table = tabulate(db,head,tablefmt="pretty")
			print(table)
		elif ch==11:
			# 11
			crsr.execute("SELECT DISTINCT Event.Ename FROM Event")
			db = crsr.fetchall()
			head = ["ENAME"]
			table = tabulate(db,head,tablefmt="pretty")
			print(table)
			us_in = input("Enter the name of the Event: ")
			print("\n")
			crsr.execute("SELECT Student.ROLL, Student.Name FROM Student INNER JOIN StudentEvent ON Student.ROLL= StudentEvent.ROLL WHERE StudentEvent.EID = ( SELECT Event.EID FROM Event WHERE Ename=%s ) ;",(us_in,))
			db = crsr.fetchall()
			head = ["ROLL","NAME"]
			table = tabulate(db,head,tablefmt="pretty")
			print(table)
		else:
			return


def connect():
	connection=None 
	try:
		params=config()
		print('Connecting to the Postgresql database')
		connection = psycopg2.connect(**params)

		crsr = connection.cursor()
		fun(crsr)
		crsr.close()
	except(Exception,psycopg2.DatabaseError) as error:
		print(error)
	finally:
		if connection is not None:
			connection.close()
			print('database terminated')

if __name__ == "__main__":
	connect()