/**************************************************************************
 *
 *  Command queue functions
 *  It's used by read_dbx who want to know which command was activated 
 *  But We do not use this facility up to now 
 **************************************************************************/

/*  Append command to end of the command queue and send the command to dbx */

void send_command(command)
char *command;
{
    CommandRec *p, *q, *r;

#ifdef BSD 
    /* Save the command if it is not a blank command; else use the 
       last saved command instead */
    if (strcspn(command, " \n"))
	strcpy(savedCommand, command);
    else
	strcpy(command, savedCommand);
#endif

    p = (CommandRec *)XtNew(CommandRec);
    p->command = XtNewString(command);
    p->next = NULL;
    if (!commandQueue)
	commandQueue = p;
    else {
	q = commandQueue;
	while (r = q->next)
	    q = r;
	q->next = p;
    }
    write_scilab(command);
}

/*  Read command at the head of the command queue */

char *get_command()
{
    if (commandQueue) {
	return (commandQueue->command);
    }
    else
	return NULL;
}

/*  Delete command from the head of the command queue */

void delete_command()
{
    CommandRec *p;

    if (p = commandQueue) {
	commandQueue = p->next;
	XtFree((char *)p->command);
	XtFree((char *)p);
    }
}

/*  Insert command into head of queue */

void insert_command(command)
char *command;
{
    CommandRec *p;

    p = (CommandRec *)XtNew(CommandRec);
    p->command = XtNewString(command);
    p->next = NULL;
    if (!commandQueue)
	commandQueue = p;
    else {
	p->next = commandQueue;
	commandQueue = p;
    }
}
