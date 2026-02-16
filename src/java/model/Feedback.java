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
public class Feedback {
    private int feedbackId;
    private int rating;
    private String comment;
    private boolean anonymous;
    private Date feedbackDate;
    private Renter renter;
    private Contract contract;

    public Feedback() {
    }

    public Feedback(int feedbackId, int rating, String comment, boolean anonymous, Date feedbackDate, Renter renter,
            Contract contract) {
        this.feedbackId = feedbackId;
        this.rating = rating;
        this.comment = comment;
        this.anonymous = anonymous;
        this.feedbackDate = feedbackDate;
        this.renter = renter;
        this.contract = contract;
    }

    public int getFeedbackId() {
        return feedbackId;
    }

    public void setFeedbackId(int feedbackId) {
        this.feedbackId = feedbackId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public boolean isAnonymous() {
        return anonymous;
    }

    public void setAnonymous(boolean anonymous) {
        this.anonymous = anonymous;
    }

    public Date getFeedbackDate() {
        return feedbackDate;
    }

    public void setFeedbackDate(Date feedbackDate) {
        this.feedbackDate = feedbackDate;
    }

    public Renter getRenter() {
        return renter;
    }

    public void setRenter(Renter renter) {
        this.renter = renter;
    }

    public Contract getContract() {
        return contract;
    }

    public void setContract(Contract contract) {
        this.contract = contract;
    }
}
