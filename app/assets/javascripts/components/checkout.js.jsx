var freeDays = [];

var Checkout = React.createClass({
  propTypes: {
    pickUp: React.PropTypes.node,
    dropOff: React.PropTypes.node,
    rentalAmount: React.PropTypes.node,
    serviceFee: React.PropTypes.node,
    totalAmount: React.PropTypes.node,
    securityDeposit: React.PropTypes.node,
    totalNights: React.PropTypes.node,
    minimumStay: React.PropTypes.node
  },

  getInitialState: function() {
    return {};
  },

  handleSubmit: function(e) {
    e.preventDefault();
    var pickup = this.state.pickUp,
      dropoff = this.state.dropOff,
      totalAmount = this.state.totalAmount,
      rentalAmount = this.state.rentalAmount,
      totalNights = this.state.totalNights,
      serviceFee = this.state.serviceFee,
      securityDeposit = this.state.securityDeposit;
    if (!pickup || !dropoff) {
      return;
    }
    $.ajax({
      url: this.props.bookingUrl,
      dataType: 'json',
      type: 'POST',
      data: { 'booking': {
          'checkIn': pickup,
          'checkOut': dropoff,
          'totalAmount': totalAmount,
          'rentalAmount': rentalAmount,
          'totalNights': totalNights,
          'serviceFee': serviceFee,
          'securityDeposit': securityDeposit
        }
      },
      success: function(data) {
        // this.setState({data: data});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },

  fetchFreeDays: function(year, month) {
    var date = '',
      day = '1',
      vehicle_id = '1';

    if (year != undefined && month != undefined) {
      var date = day + '/' + month.toString() + '/' + year.toString();
    }
    $.get('/vehicles/' + vehicle_id + '/reservations/available?date=' + date, function(data) {
      $.each(data, function(index, value) {
        freeDays.push(value);
      });
      this.initCal();
    }.bind(this));
  },

  highlightDays: function(date) {
    for (var i = 0; i < freeDays.length; i++) {
      if (freeDays[i].on_date.toString() == date.strftime('%Y-%m-%d')) {
        if (freeDays[i].state == 'unavailable') {
          return [true, 'ui-state-disabled ui-datepicker-unselectable available', 'Date not available']; // [0] = true | false if this day is selectable, [1] = class to add, [2] = tooltip to display
        }
        if (freeDays[i].state == 'booked') {
          return [true, 'ui-state-disabled ui-datepicker-unselectable booked', 'Date not available']; // [0] = true | false if this day is selectable, [1] = class to add, [2] = tooltip to display
        }
      }
    }
    return [true, ''];
  },

  initCal: function(){
    var nowTemp = new Date(),
      vehicle_id = '1',
      $pickup = $('#pickup'),
      $dropoff = $('#dropoff'),
      now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0),
      url = '/vehicles/' + vehicle_id + '/reservations/price';

    $pickup.datepicker({
      dateFormat: 'mm/dd/y',
      minDate: 0,
      beforeShowDay: this.highlightDays,
      onChangeMonthYear: this.fetchFreeDays,
      onRender: function(date) {
        return date.valueOf() < now.valueOf() ? 'disabled' : '';
      },
      onSelect: function(date, inst) {
        var checkoutDate = $dropoff.datepicker('getDate'),
          checkinDate = $pickup.datepicker('getDate');
        if (checkinDate > checkoutDate) {
          var newDate = new Date(checkinDate)
          newDate.setDate(newDate.getDate() + 1);
          $dropoff.datepicker("setDate", newDate);
        }

        checkoutDate = newDate || checkoutDate
        var timeDiff = Math.abs(checkoutDate.getTime() - checkinDate.getTime()),
          diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24));

        if(diffDays < this.props.minimumStay) {
          var numOfDays = this.props.minimumStay + diffDays;
          checkoutDate.setDate(checkoutDate.getDate() + numOfDays);
          $dropoff.datepicker("setDate", checkoutDate);
          $('.minimum-stay').addClass('bg-warning');
        }

        this.handlePrice(url, checkinDate.strftime('%m/%d/%y'), checkoutDate.strftime('%m/%d/%y'));
      }.bind(this)
    });

    $dropoff.datepicker({
      dateFormat: 'mm/dd/y',
      minDate: 0,
      beforeShowDay: this.highlightDays,
      onChangeMonthYear: this.fetchFreeDays,
      onRender: function(date) {
        return date.valueOf() <= checkin.date.valueOf() ? 'disabled' : '';
      },
      onSelect: function(date, inst) {
        var checkoutDate = $dropoff.datepicker('getDate'),
          checkinDate = $pickup.datepicker('getDate');
        if (checkinDate > checkoutDate) {
          var newDate = new Date(checkoutDate)
          newDate.setDate(newDate.getDate() - 1);
          $pickup.datepicker("setDate", newDate);
          // $pickup.focus();
          // $pickup.datepicker("show");
        }
        checkinDate = newDate || checkinDate
        var timeDiff = Math.abs(checkoutDate.getTime() - checkinDate.getTime()),
          diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24));

        if(diffDays < this.props.minimumStay) {
          var numOfDays = this.props.minimumStay + diffDays;
          checkoutDate.setDate(checkoutDate.getDate() + numOfDays);
          $dropoff.datepicker("setDate", checkoutDate);
          $('.minimum-stay').addClass('bg-warning');
          console.log('min')
        }

        this.handlePrice(url, checkinDate.strftime('%m/%d/%y'), checkoutDate.strftime('%m/%d/%y'));
      }.bind(this),
      onClose: function(date, inst) {
        return;
      }.bind(this)
    });

    this.handlePrice(this.props.url, this.props.pickup, this.props.dropoff);
  },

  handlePrice: function(url, checkinDate, checkoutDate){
    $.ajax({
      url: url,
      type: 'POST',
      dataType: 'json',
      cache: false,
      data: { pickup: checkinDate, dropoff: checkoutDate },
      success: function(data) {
        this.setState(data);
        console.log(data);
        if(data.datesAvailable == false){
          $("#checkout-flash").removeClass('hide');
        } else {
          $("#checkout-flash").addClass('hide');
          $('.reservation-deposit').removeClass('hide');
          $('.table').removeClass('hide');
          // $('.minimum-stay').removeClass('bg-warning');
          $('#checkout-submit').removeClass('disabled').removeAttr('disabled');
        }
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(url, status, err.toString());
      }.bind(this)
    });
  },

  componentDidMount: function() {
    this.initCal();
    this.fetchFreeDays();
  },

  render: function() {
    return (
      <form acceptCharset="UTF-8" method="get" onSubmit={this.handleSubmit}>
        <input name="utf8" type="hidden" value="✓" />
        <div className="col-md-6">
          <div className="form-group">
            <label className="sr-only" htmlFor="checkin">Pickup</label>
            <input type="text" name="pickup" id="pickup" value={this.state.pickUp} className="form-control" />
          </div>
        </div>
        <div className="col-md-6">
          <div className="form-group">
            <label className="sr-only" htmlFor="checkout">Drop-off</label>
            <input type="text" name="dropoff" id="dropoff" value={this.state.dropOff} className="form-control" />
          </div>
        </div>
        <div className="col-md-12">
          <div className="form-group">
            <p className="help txt-center minimum-stay">Minimum Stay: {this.props.minimumStay} nights</p>
          </div>
        </div>
          <table className="table hide">
            <tbody>
              <tr>
                <td className="line-description">Total Nights</td>
                <td className="line-price">{this.state.totalNights}</td>
              </tr>
              <tr>
                <td className="line-description">Rental Amount</td>
                <td className="line-price">{this.state.rentalAmount}</td>
              </tr>
              <tr>
                <td className="line-description">Service Fee <i className="fa help-box fa-question-circle"></i></td>
                <td className="line-price">{this.state.serviceFee}</td>
              </tr>
              <tr>
                <td className="line-description total-description"><strong>Total</strong></td>
                <td className="total-price"><strong>{this.state.totalAmount}</strong></td>
              </tr>
              {/*<tr>
                <td className="line-description">Security Deposit <i className="fa help-box fa-question-circle"></i></td>
                <td className="line-price">{this.state.securityDeposit}</td>
              </tr>*/}
            </tbody>
          </table>
          <div className="row">
            <div className="col-sm-12">
            </div>
          </div>
          <div className="row">
            <div className="col-sm-12">
              <div className="reservation-deposit hide">
                <p><strong>{this.state.totalAmount}</strong> due to reserve.</p>
              </div>
            </div>
          </div>
          <div className="col-md-12">
            <button type="submit" className="btn btn-default btn-primary full-width disabled" id="checkout-submit" data-disable-with="Please Wait..." disabled>Request Booking</button>
          </div>
        </form>
    );
  }
});
