/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author hao23
 */
public class FeedbackResponse {
    private int responseId;
    private String responseText;
    private Date responseDate;
    private Feedback feedback;
    private InternalUser internalUser;

    public FeedbackResponse() {
    }

    public FeedbackResponse(int responseId, String responseText, Date responseDate, Feedback feedback, InternalUser internalUser) {
        this.responseId = responseId;
        this.responseText = responseText;
        this.responseDate = responseDate;
        this.feedback = feedback;
        this.internalUser = internalUser;
    }

    public int getResponseId() {
        return responseId;
    }

    public void setResponseId(int responseId) {
        this.responseId = responseId;
    }

    public String getResponseText() {
        return responseText;
    }

    public void setResponseText(String responseText) {
        this.responseText = responseText;
    }

    public Date getResponseDate() {
        return responseDate;
    }

    public void setResponseDate(Date responseDate) {
        this.responseDate = responseDate;
    }

    public Feedback getFeedback() {
        return feedback;
    }

    public void setFeedback(Feedback feedback) {
        this.feedback = feedback;
    }

    public InternalUser getInternalUser() {
        return internalUser;
    }

    public void setInternalUser(InternalUser internalUser) {
        this.internalUser = internalUser;
    }
    
    
}
