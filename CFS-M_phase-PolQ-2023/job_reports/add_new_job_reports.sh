#############################################################
# must export 
#   export MDI=/path/to/mdi
#############################################################
if [ "$MDI" = "" ]; then
    echo "must export:"
    echo "  export MDI=/path/to/mdi"
    exit 1
fi

# save the most recent job report for every unique job for every unique project
# here only adding new projects, leaving existing project reports as is

JOB_REPORTS_DIR=$PWD
mkdir -p find_by_project
mkdir -p assemble_all_projects
cd ..

CELL_LINES='GM12878 HF1 HCT116'
echo "adding find reports by cell line"
for CELL_LINE in $CELL_LINES; do
    echo $CELL_LINE
    cd find_by_project/$CELL_LINE
    CELL_LINE_DIR=$JOB_REPORTS_DIR/find_by_project/$CELL_LINE
    mkdir -p $CELL_LINE_DIR
    JOB_FILES=`ls -1 *.yml | grep -v svCapture.yml`
    for JOB_FILE in $JOB_FILES; do
        echo "  "$JOB_FILE
        JOB_FILE_NAME=`echo $JOB_FILE | sed s/.yml//`
        JOB_REPORT_FILE=$CELL_LINE_DIR/$JOB_FILE_NAME.report_all.txt
        if [ -f $JOB_REPORT_FILE ]; then
            echo "    exists, skipping"
        else
            echo "    status"
            JOB_IDS=`$MDI $JOB_FILE status | tee $JOB_REPORT_FILE | perl $JOB_REPORTS_DIR/dump_job_reports.pl`
            echo "    report $JOB_IDS"
            for JOB_ID in $JOB_IDS; do 
                $MDI $JOB_FILE report -j $JOB_ID >> $JOB_REPORT_FILE
            done
        fi

    done
    cd ../..
done
echo "find reports done"
echo

echo "adding assemble reports"
cd assemble_all_projects
JOB_FILES=`ls -1 *.yml | grep -v svCapture.yml`
for JOB_FILE in $JOB_FILES; do
    echo "  "$JOB_FILE
    JOB_FILE_NAME=`echo $JOB_FILE | sed s/.yml//`
    JOB_REPORT_FILE=$JOB_REPORTS_DIR/assemble_all_projects/$JOB_FILE_NAME.report_all.txt
    if [ -f $JOB_REPORT_FILE ]; then
        echo "    exists, skipping"
    else
        echo "    status"
        $MDI $JOB_FILE status > $JOB_REPORT_FILE
        echo "    report"
        $MDI $JOB_FILE report -j all >> $JOB_REPORT_FILE
    fi
done
echo "assemble reports done"
